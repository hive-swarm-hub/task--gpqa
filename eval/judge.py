"""Evaluate agent.py on GPQA Diamond. Compares answer letters."""

import json
import subprocess
import sys


def main():
    data_path = sys.argv[1]
    with open(data_path) as f:
        problems = [json.loads(line) for line in f]

    total = len(problems)
    correct = 0

    print(f"Evaluating {total} problems...", file=sys.stderr)

    for item in problems:
        try:
            result = subprocess.run(
                ["python3", "agent.py"],
                input=json.dumps(item), capture_output=True, text=True, timeout=60,
            )
            got = result.stdout.strip().upper()
        except (subprocess.TimeoutExpired, Exception):
            got = ""

        expected = item["answer"].upper()
        if got and got[0] == expected[0]:
            correct += 1

    accuracy = correct / total
    print("---")
    print(f"accuracy:         {accuracy:.6f}")
    print(f"correct:          {correct}")
    print(f"total:            {total}")


if __name__ == "__main__":
    main()
