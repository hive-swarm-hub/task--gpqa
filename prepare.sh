#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading GPQA..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random

random.seed(42)
items = list(load_dataset('ankner/gpqa', split='train'))
random.shuffle(items)

n = min(len(items) // 2, 150)

dev_out = pathlib.Path('data/dev.jsonl')
with dev_out.open('w') as f:
    for row in items[:n]:
        f.write(json.dumps({'question': row['question'], 'answer': row['answer'], 'choices': row.get('choices', [])}) + '
')

test_out = pathlib.Path('data/test.jsonl')
with test_out.open('w') as f:
    for row in items[n:n+min(n,150)]:
        f.write(json.dumps({'question': row['question'], 'answer': row['answer'], 'choices': row.get('choices', [])}) + '
')

print(f'Dev:  {n} problems -> {dev_out}')
print(f'Test: {min(n,150)} problems -> {test_out}')
"
echo "Done."
