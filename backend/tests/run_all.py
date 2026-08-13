"""
Layer 8 — Evaluation & Reliability Layer
Runs the full test suite (Pytest deterministic tests + DeepEval quality tests)
in one go and prints a summary.
"""
import subprocess
import sys

def run(label, args):
    print(f"\n{'='*70}\n{label}\n{'='*70}")
    result = subprocess.run(args, capture_output=False)
    return result.returncode

if __name__ == "__main__":
    results = {}

    results["Layer 7 Action Layer (Pytest)"] = run(
        "Layer 7 Action Layer (Pytest)",
        ["pytest", "tests/test_action_layer.py", "-v"]
    )

    results["Wage Advisor (DeepEval)"] = run(
        "Wage Advisor (DeepEval)",
        ["pytest", "tests/test_wage_advisor_eval.py", "-v"]
    )

    results["Job Matching (DeepEval)"] = run(
        "Job Matching (DeepEval)",
        ["pytest", "tests/test_job_matching_eval.py", "-v"]
    )

    results["Safety Check (DeepEval)"] = run(
        "Safety Check (DeepEval)",
        ["pytest", "tests/test_safety_check_eval.py", "-v"]
    )

    results["Chatbot + RAG (DeepEval)"] = run(
        "Chatbot + RAG (DeepEval)",
        ["pytest", "tests/test_chatbot_eval.py", "-v"]
    )

    print(f"\n\n{'='*70}\nSUMMARY\n{'='*70}")
    all_passed = True
    for label, code in results.items():
        status = "PASSED" if code == 0 else "FAILED"
        if code != 0:
            all_passed = False
        print(f"{status:8} — {label}")

    print(f"\n{'ALL SUITES PASSED' if all_passed else 'SOME SUITES FAILED'}")
    sys.exit(0 if all_passed else 1)