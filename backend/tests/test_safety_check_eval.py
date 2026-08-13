import uuid
import requests
from deepeval import assert_test
from deepeval.metrics import GEval
from deepeval.test_case import LLMTestCase, SingleTurnParams
from groq_judge import GroqJudge


def _check_safety(base_url, job_title, job_description, wage, location,
                   contractor_phone="", contractor_name=""):
    response = requests.post(f"{base_url}/check_safety", json={
        "job_title": job_title,
        "job_description": job_description,
        "wage": wage,
        "location": location,
        "contractor_phone": contractor_phone,
        "contractor_name": contractor_name,
    })
    assert response.status_code == 200
    return response.json()


def test_safety_check_flags_suspicious_job(base_url):
    tag = uuid.uuid4().hex[:6]
    result = _check_safety(
        base_url,
        job_title=f"URGENT Masons Needed NOW {tag}",
        job_description=(
            "Guaranteed ₹5000/day! Pay a ₹2000 registration fee upfront before "
            "starting. Limited seats, contact immediately, no experience needed."
        ),
        wage=f"5000-{tag}",
        location=f"Unknown Location {tag}",
        contractor_name="Unverified Contractor"
    )

    assert result["verdict"] == "SUSPICIOUS"
    assert isinstance(result["trust_score"], int)
    assert result["trust_score"] < 50

    quality = GEval(
        name="SafetyReasoningQuality",
        criteria=(
            "Determine if the reason given coherently justifies flagging this job "
            "as suspicious, referencing red flags such as upfront payment requests, "
            "unrealistic wage, or urgency language."
        ),
        evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
        threshold=0.5,
        model=GroqJudge()
    )
    test_case = LLMTestCase(
        input="Job with upfront payment request, unrealistic wage, and urgency language",
        actual_output=result["reason"]
    )
    assert_test(test_case, [quality])


def test_safety_check_passes_normal_job(base_url):
    tag = uuid.uuid4().hex[:6]
    result = _check_safety(
        base_url,
        job_title=f"Mason needed for house construction {tag}",
        job_description=(
            "Need an experienced mason for a 2-storey house construction. "
            "Work starts next week, daily wage paid at end of each day."
        ),
        wage=f"500-{tag}",
        location=f"Konaje, Mangalore {tag}",
        contractor_name="Regular Contractor"
    )

    assert result["verdict"] == "SAFE"
    assert isinstance(result["trust_score"], int)
    assert result["trust_score"] >= 50

    quality = GEval(
        name="SafetyReasoningQuality",
        criteria=(
            "Determine if the reason given coherently justifies treating this job "
            "as safe, given it has no red flags like upfront payment or unrealistic wages."
        ),
        evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
        threshold=0.5,
        model=GroqJudge()
    )
    test_case = LLMTestCase(
        input="Normal construction job with standard wage, no red flags",
        actual_output=result["reason"]
    )
    assert_test(test_case, [quality])