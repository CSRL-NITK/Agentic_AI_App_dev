import uuid
import requests
from deepeval import assert_test
from deepeval.metrics import GEval
from deepeval.test_case import LLMTestCase, SingleTurnParams
from groq_judge import GroqJudge


def _match_jobs(base_url, worker_skill, worker_location, min_wage=0, max_wage=0, worker_experience=""):
    response = requests.post(f"{base_url}/match_jobs", json={
        "worker_skill": worker_skill,
        "worker_location": worker_location,
        "min_wage": min_wage,
        "max_wage": max_wage,
        "worker_experience": worker_experience,
    })
    assert response.status_code == 200
    return response.json()["result"]


def test_job_matching_finds_relevant_job(db, base_url):
    skill = f"TestSkillMatch{uuid.uuid4().hex[:6]}"
    location = f"TestCityMatch{uuid.uuid4().hex[:6]}"
    job_id = f"test_job_{uuid.uuid4().hex[:8]}"

    db.collection("jobs").document(job_id).set({
        "title": f"{skill} needed in {location}",
        "skill": skill,
        "location": location,
        "wage": 500,
        "contractorPhone": "9999999999",
        "status": "open",
    })

    try:
        result_text = _match_jobs(base_url, skill, location, min_wage=400, max_wage=800, worker_experience="3")

        quality = GEval(
            name="JobMatchRelevancy",
            criteria=(
                f"Determine if the response reasonably identifies and ranks job(s) "
                f"relevant to a worker with skill '{skill}' in location '{location}', "
                f"with brief reasoning for the match."
            ),
            evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
            threshold=0.5,
            model=GroqJudge()
        )
        test_case = LLMTestCase(
            input=f"Worker skill: {skill}, location: {location}, wage range 400-800",
            actual_output=result_text
        )
        assert_test(test_case, [quality])

    finally:
        db.collection("jobs").document(job_id).delete()


def test_job_matching_no_match_is_honest(base_url):
    skill = f"NoSuchSkill{uuid.uuid4().hex[:6]}"
    location = f"NoSuchCity{uuid.uuid4().hex[:6]}"

    result_text = _match_jobs(base_url, skill, location)
    print("\n\n===== FULL AGENT OUTPUT =====")
    print(result_text)
    print("===== END OUTPUT =====\n\n")

    honesty = GEval(
        name="NoMatchHonesty",
        criteria=(
            "Determine if the response honestly states that no matching or relevant "
            "jobs were found, rather than inventing/hallucinating a job that wasn't provided."
        ),
        evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
        threshold=0.5,
        model=GroqJudge()
    )
    test_case = LLMTestCase(
        input=f"Worker skill: {skill}, location: {location} (no such jobs exist)",
        actual_output=result_text
    )
    assert_test(test_case, [honesty])