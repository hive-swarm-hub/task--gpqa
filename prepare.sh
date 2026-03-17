#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading GPQA..."
python3 << 'PY'
from datasets import load_dataset
import json, pathlib
ds = load_dataset('ankner/gpqa', split='train')
out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in ds:
        f.write(json.dumps({"question": row["question"], "answer": row["answer"], "choices": row.get("choices", [])}) + '\n')
print(f'Wrote {len(ds)} problems to {out}')
PY
echo "Done."
