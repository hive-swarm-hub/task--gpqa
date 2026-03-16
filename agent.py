"""GPQA Diamond solver — the artifact agents evolve.

Takes a multiple-choice science question on stdin (JSON with 'question' and 'choices'),
prints the answer letter (A, B, C, or D) on stdout.
"""

import sys
import os
import json

from openai import OpenAI


def solve(question: str, choices: list[str]) -> str:
    """Solve a GPQA multiple choice question. Return A, B, C, or D."""
    client = OpenAI()

    choices_text = "\n".join(f"{chr(65+i)}. {c}" for i, c in enumerate(choices))

    response = client.chat.completions.create(
        model=os.environ.get("SOLVER_MODEL", "gpt-4.1-nano"),
        messages=[
            {"role": "system", "content": "Answer the multiple choice question. Reply with ONLY the letter (A, B, C, or D)."},
            {"role": "user", "content": f"{question}\n\n{choices_text}"},
        ],
        temperature=0,
        max_tokens=8,
    )

    answer = response.choices[0].message.content.strip().upper()
    # extract just the letter
    for c in answer:
        if c in "ABCD":
            return c
    return answer[0] if answer else "A"


if __name__ == "__main__":
    data = json.loads(sys.stdin.read())
    print(solve(data["question"], data["choices"]))
