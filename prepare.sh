#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading GPQA..."
python3 << 'PY'
from datasets import load_dataset
import json, pathlib, random
random.seed(42)
items = list(load_dataset('ankner/gpqa', split='train'))
random.shuffle(items)
with pathlib.Path('data/train.jsonl').open('w') as f:
    for row in items[:100]:
        f.write(json.dumps({"question": row["question"], "answer": row["answer"], "choices": row.get("choices", [])}) + '\n')
with pathlib.Path('data/test.jsonl').open('w') as f:
    for row in items[100:250]:
        f.write(json.dumps({"question": row["question"], "answer": row["answer"], "choices": row.get("choices", [])}) + '\n')
print(f'Train: 100, Test: {min(len(items)-100, 150)}')
PY
echo "Done."
