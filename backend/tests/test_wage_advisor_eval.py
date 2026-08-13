#Now create `tests/test_wage_advisor_eval.py`:
import uuid
import requests
from deepeval import assert_test
from deepeval.metrics import GEval
from deepeval.test_case import LLMTestCase, SingleTurnParams
from groq_judge import GroqJudge


def _check_wage(base_url, skill, location, offered_wage):
    response = requests.post(f"{base_url}/check_wage", json={
        "skill": skill,
        "location": location,
        "offered_wage": offered_wage
    })
    assert response.status_code == 200
    return response.json()["result"]


def test_wage_advisor_low_wage(base_url):
    location = f"TestTownLow{uuid.uuid4().hex[:6]}"
    result_text = _check_wage(base_url, "mason", location, 200)  # benchmark ~450-600
    assert "LOW" in result_text.upper()

    quality = GEval(
        name="WageReasoningQuality",
        criteria=(
            "Determine if the response gives a clear verdict with a coherent, "
            "wage-market-relevant explanation for why an offered wage of ₹200/day "
            "for a mason is considered low, given a typical benchmark range of "
            "roughly ₹450–₹600/day."
        ),
        evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
        threshold=0.5,
        model=GroqJudge()
    )
    test_case = LLMTestCase(
        input=f"Mason in {location} offered ₹200/day; benchmark range ₹450–₹600/day.",
        actual_output=result_text
    )
    assert_test(test_case, [quality])


def test_wage_advisor_fair_wage(base_url):
    location = f"TestTownFair{uuid.uuid4().hex[:6]}"
    result_text = _check_wage(base_url, "mason", location, 520)  # within benchmark
    assert "FAIR" in result_text.upper()

    quality = GEval(
        name="WageReasoningQuality",
        criteria=(
            "Determine if the response gives a clear verdict with a coherent, "
            "wage-market-relevant explanation for why an offered wage of ₹520/day "
            "for a mason is considered fair, given a typical benchmark range of "
            "roughly ₹450–₹600/day."
        ),
        evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
        threshold=0.5,
        model=GroqJudge()
    )
    test_case = LLMTestCase(
        input=f"Mason in {location} offered ₹520/day; benchmark range ₹450–₹600/day.",
        actual_output=result_text
    )
    assert_test(test_case, [quality])


def test_wage_advisor_high_wage(base_url):
    location = f"TestTownHigh{uuid.uuid4().hex[:6]}"
    result_text = _check_wage(base_url, "mason", location, 900)  # well above benchmark
    assert "HIGH" in result_text.upper()

    quality = GEval(
        name="WageReasoningQuality",
        criteria=(
            "Determine if the response gives a clear verdict with a coherent, "
            "wage-market-relevant explanation for why an offered wage of ₹900/day "
            "for a mason is considered high, given a typical benchmark range of "
            "roughly ₹450–₹600/day."
        ),
        evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
        threshold=0.5,
        model=GroqJudge()
    )
    test_case = LLMTestCase(
        input=f"Mason in {location} offered ₹900/day; benchmark range ₹450–₹600/day.",
        actual_output=result_text
    )
    assert_test(test_case, [quality])
