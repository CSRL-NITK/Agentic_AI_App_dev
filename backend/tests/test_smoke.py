import os
from deepeval import assert_test
from deepeval.metrics import GEval
from deepeval.test_case import LLMTestCase, SingleTurnParams
from groq_judge import GroqJudge

from dotenv import load_dotenv
load_dotenv()
def test_smoke():
    correctness = GEval(
        name="Correctness",
        criteria="Determine if the 'actual output' is factually correct based on the 'expected output'.",
        evaluation_params=[SingleTurnParams.ACTUAL_OUTPUT, SingleTurnParams.EXPECTED_OUTPUT],
        threshold=0.5,
        model=GroqJudge()
    )
    test_case = LLMTestCase(
        input="What is the capital of Karnataka?",
        actual_output="The capital of Karnataka is Bengaluru.",
        expected_output="Bengaluru"
    )
    assert_test(test_case, [correctness])