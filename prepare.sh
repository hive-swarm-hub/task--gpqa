#!/usr/bin/env bash
# Download GPQA Diamond dataset. Run once.
set -euo pipefail

mkdir -p data

echo "Downloading GPQA Diamond..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random

random.seed(42)
ds = load_dataset('ankner/gpqa', split='train')
# filter to diamond subset and sample 50
diamond = [r for r in ds if r.get('subset', '') == 'gpqa_diamond']
if not diamond:
    diamond = list(ds)  # fallback if no subset field
random.shuffle(diamond)
diamond = diamond[:50]

out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in diamond:
        # choices are in columns: Correct Answer, Incorrect Answer 1, 2, 3
        correct = row['Correct Answer']
        choices = [correct, row['Incorrect Answer 1'], row['Incorrect Answer 2'], row['Incorrect Answer 3']]
        random.shuffle(choices)
        answer_idx = choices.index(correct)
        answer_letter = 'ABCD'[answer_idx]
        f.write(json.dumps({
            'question': row['Question'],
            'choices': choices,
            'answer': answer_letter,
        }) + '\n')

print(f'Wrote {len(diamond)} problems to {out}')
"

echo "Done. $(wc -l < data/test.jsonl) problems in data/test.jsonl"
