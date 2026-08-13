import re
import uuid
import requests
from deepeval import assert_test
from deepeval.metrics import GEval, FaithfulnessMetric
from deepeval.test_case import LLMTestCase, SingleTurnParams
from groq_judge import GroqJudge


def _chat(base_url, message, language="auto", worker_phone=""):
    response = requests.post(f"{base_url}/chat", json={
        "message": message,
        "language": language,
        "worker_phone": worker_phone,
    })
    assert response.status_code == 200
    return response.json()


def test_chatbot_faithful_to_knowledge_base(base_url):
    result = _chat(base_url, "What safety precautions should I take for electrical work?", language="English")
    reply = result["reply"]
    context = result.get("context", "")

    assert len(reply.strip()) > 0

    if context.strip():
        faithfulness = FaithfulnessMetric(threshold=0.5, model=GroqJudge())
        test_case = LLMTestCase(
            input="What safety precautions should I take for electrical work?",
            actual_output=reply,
            retrieval_context=[context]
        )
        assert_test(test_case, [faithfulness])


def test_chatbot_kannada_language(base_url):
    result = _chat(base_url, "ಎಲೆಕ್ಟ್ರಿಕಲ್ ಕೆಲಸಕ್ಕೆ ಸುರಕ್ಷತಾ ಮುನ್ನೆಚ್ಚರಿಕೆಗಳೇನು?", language="Kannada")
    reply = result["reply"]

    assert len(reply.strip()) > 0
    kannada_chars = re.findall(r'[\u0C80-\u0CFF]', reply)
    assert len(kannada_chars) > 5, f"Reply doesn't look like Kannada script: {reply}"

    quality = GEval(
        name="KannadaRelevancy",
        criteria="Determine if the response is relevant and helpful in answering a question about electrical work safety precautions, regardless of exact wording.",
        evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
        threshold=0.5,
        model=GroqJudge()
    )
    test_case = LLMTestCase(
        input="Electrical work safety precautions (asked in Kannada)",
        actual_output=reply
    )
    assert_test(test_case, [quality])


def test_chatbot_hindi_language(base_url):
    result = _chat(base_url, "बिजली के काम के लिए सुरक्षा सावधानियां क्या हैं?", language="Hindi")
    reply = result["reply"]

    assert len(reply.strip()) > 0
    hindi_chars = re.findall(r'[\u0900-\u097F]', reply)
    assert len(hindi_chars) > 5, f"Reply doesn't look like Hindi script: {reply}"

    quality = GEval(
        name="HindiRelevancy",
        criteria="Determine if the response is relevant and helpful in answering a question about electrical work safety precautions, regardless of exact wording.",
        evaluation_params=[SingleTurnParams.INPUT, SingleTurnParams.ACTUAL_OUTPUT],
        threshold=0.5,
        model=GroqJudge()
    )
    test_case = LLMTestCase(
        input="Electrical work safety precautions (asked in Hindi)",
        actual_output=reply
    )
    assert_test(test_case, [quality])



from deepeval.metrics import ContextualRelevancyMetric

def test_chatbot_contextual_relevancy(base_url):
    question = "What safety precautions should I take for electrical work?"
    result = _chat(base_url, question, language="English")
    reply = result["reply"]
    context = result.get("context", "")

    assert len(reply.strip()) > 0

    if context.strip():
        relevancy = ContextualRelevancyMetric(threshold=0.5, model=GroqJudge())
        test_case = LLMTestCase(
            input=question,
            actual_output=reply,
            retrieval_context=[context]
        )
        assert_test(test_case, [relevancy])

