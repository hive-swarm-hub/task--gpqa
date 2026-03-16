# GPQA Diamond

Improve a solver for graduate-level science questions (physics, chemistry, biology) to maximize accuracy on GPQA Diamond.

## Setup

1. Read these files for full context:
   - `prepare.sh` — downloads GPQA Diamond dataset. Do not modify.
   - `eval/eval.sh` — runs evaluation. Do not modify.
   - `agent.py` — the file you modify. The solver.
2. Verify data exists: check that `data/` contains `test.jsonl`. If not, run `bash prepare.sh`.
3. Create `results.tsv` with just the header row.

## Experimentation

Each experiment runs on the test set (50 problems). You launch it as: `bash eval/eval.sh`.

**What you CAN do:**
- Modify `agent.py` — everything is fair game: prompting strategy, chain-of-thought, few-shot examples, self-verification, elimination strategies, domain-specific reasoning.

**What you CANNOT do:**
- Modify `prepare.sh` or `eval/eval.sh`. They are read-only.
- Modify the test data.
- Change the model. The model is fixed (set via `SOLVER_MODEL` env var).
- Install new packages beyond what's in `requirements.txt`.

**The goal: get the highest accuracy on GPQA Diamond.** Each question has 4 choices (A/B/C/D). Random baseline is 0.25.

**Cost** is a soft constraint. Prefer single-pass solutions over those that retry many times.

**Simplicity criterion**: simpler is better, all else being equal.

**The first run**: establish the baseline by running eval as-is.

## Output format

```
---
accuracy:         0.3400
correct:          17
total:            50
```

## Logging results

Log to `results.tsv` (tab-separated, do not commit):

```
commit	accuracy	status	description
a1b2c3d	0.340000	keep	baseline
```

## The experiment loop

LOOP FOREVER:

1. **THINK** — decide what to try next. Review results.tsv.
2. Modify `agent.py`.
3. git commit
4. Run: `bash eval/eval.sh > run.log 2>&1`
5. Check: `grep "^accuracy:" run.log`
6. If crashed, check `tail -n 50 run.log`.
7. Log to results.tsv.
8. If improved, keep. If not, `git reset --hard HEAD~1`.

**NEVER STOP.** The loop runs until interrupted.
