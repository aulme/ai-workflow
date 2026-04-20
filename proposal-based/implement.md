# Implement a proposal

**In:** a proposal, ideally sharpened and split. **Out:** shipped code + proposal moved to `done/`.

Read [`README.md`](./README.md) for the proposal-based workflow rules before running this procedure.

## Steps

1. **Pre-flight.** Re-read with implementer's eye. Classify remaining questions:
   - **Significant** (would change design or force a non-obvious mid-code choice) → stop and run **sharpen a proposal**.
   - **Trivial** (naming, small lib choice, formatting) → list them, ask the human to accept, proceed on approval.
2. **Per-stage loop:**
   1. Implement the stage.
   2. Run all relevant quality gates (typecheck, lint, unit, integration, e2e). Fix anything red.
   3. If a **significant** question surfaces mid-code, pause and ask.
   4. Commit + push for this stage; message references proposal + stage.
   5. Update the proposal's `Status` / stage checklist.
   6. **Pause** with a ≤4-paragraph summary: what was built, important choices, surprises worth flagging, what's next.
   7. Wait for "continue" before the next stage.
3. **Final stage.** Perform the absorption step: update the canonical spec(s), add the "absorbed into <link>" note to the proposal, move it to `done/`. Commit alongside the final code change.
