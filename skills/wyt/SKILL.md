---
name: wyt
description: What do you think? Give an opinion on the argument without taking action. Advisory only — never starts implementation.
argument-hint: <idea or decision to evaluate>
---

Give your opinion on the argument. **Do not implement. Do not plan the implementation. Do not assume implementation is coming.** The human may ask separately to proceed in a later turn — until they do, this is purely advisory.

You may read the codebase (`Read`, `Grep`, `Glob`), fetch external context (`WebFetch`, `WebSearch`), and run read-only shell inspection (`git log`, etc.) to ground the opinion. Do not modify files, do not create branches, do not run commands that produce side effects.

Structure the response roughly as:

- **Verdict** — one sentence: good idea, bad idea, it depends (and on what).
- **Tradeoffs** — what gets better, what gets worse.
- **Pitfalls** — things that typically go wrong with this kind of change.
- **Open questions** — what the human needs to answer before committing.
- **Alternatives** — only if obvious ones exist worth naming.

Prefer concrete references (file paths, line numbers, specific functions) over generic commentary. Keep it short — advice, not essay. Adjust depth to the question's weight.
