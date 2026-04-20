# Sharpen a proposal

**In:** an existing proposal. **Out:** implementable as-is without further major decisions.

Read [`README.md`](./README.md) for the proposal-based workflow rules before running this procedure.

## Steps

1. **Deep review.** Hunt for:
   - Open issues (hand-waved, TBD, implied-but-not-specified).
   - Internal contradictions.
   - Unwarranted assumptions (especially about existing code or dependencies — verify against the repo when feasible).
   - Missing tradeoffs (a choice made without acknowledging alternatives).
   - Unclear scope / boundaries / non-goals.
   - Size risk — if too big for one session, recommend **split the proposal** next.
2. **Post the list** as numbered questions with clear resolutions.
3. **Record the list** in the proposal as an `Open questions (sharpening)` checklist.
4. **Work items one by one.** For each: propose options with tradeoffs, recommend one, edit the proposal to reflect the decision, tick the checklist. No silent batching.
5. **Re-review** after resolutions — new questions often surface downstream.
6. **Done when** the checklist is empty (or holds only explicitly-deferred items) and you'd comfortably implement as-is.
7. **Stop.** Report sharpened status. Recommend **split the proposal** if scope still feels too big.
