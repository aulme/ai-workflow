# Proposal-Based Workflow

A lightweight, portable workflow for deciding and documenting non-trivial changes before they land as code. Originally distilled from a multi-service engineering repo; intentionally written to be reusable across projects of any size.

---

## Why

Large or architectural changes benefit from a short written artifact that:

- Names the problem before jumping to a solution.
- Makes tradeoffs visible so the human and AI agents can argue about the *design*, not the diff.
- Leaves a trail: future readers (and future AI sessions) can see why the code looks the way it does.

The proposal is the thing humans and agents negotiate over. Code changes follow a decision — not the other way around.

---

## Directory layout

```
specs/proposals/                 # open proposals (unimplemented)
specs/proposals/done/            # implemented — kept for design history
specs/proposals/deprioritized/   # paused or explicitly won't-do
```

Every repo following this workflow **must also maintain a canonical current-state spec** — a single living design document describing what the system is today. Proposals describe changes *to* the canonical spec. See the **Canonical spec** section below for required contents and role.

---

## When to write a proposal

Write (or extend) a proposal when the change is one of:

- Architectural or cross-cutting (touches multiple components, services, or layers).
- A new subsystem, data model, or external integration.
- A change with real tradeoffs worth naming before committing.
- A multi-step migration.

Do **not** write a proposal for:

- Small bug fixes.
- Local refactors.
- Obvious additions with a single reasonable design.

Before drafting, **scan open proposals for overlap** and prefer extending an existing one over creating a near-duplicate.

---

## Proposal format

Keep it lightweight. A proposal is a single markdown file with at least:

- **Title**
- **Status** — `Draft` / `Accepted` / `In Progress` / `Implemented` / `Future` / `Deprioritized`
- **Last updated** — ISO date
- **Problem** — what's broken, missing, or painful
- **Scope / goals** — what this proposal does and explicitly does not cover
- **Design** — the proposed change, concrete enough to implement from
- **Implementation / migration notes** — how it gets delivered, in what order
- **Open questions / follow-up work** — optional

Use Mermaid for diagrams. No ASCII art. Readable prose beats padding.

---

## Lifecycle

1. **Draft.** Human or agent creates `specs/proposals/<slug>.md`. Existing open proposals are checked for overlap first.
2. **Active.** Discussion and revisions happen in-place. Agents may edit freely while the human is engaged.
3. **Implementation gate.** When the design is ready to build, the agent **must stop and ask the human** before making code changes. No silent transition from editing the proposal to editing source files.
4. **Implementation.** Code lands in regular changes. The proposal's `Status` moves to `In Progress`, then `Implemented`.
5. **Absorption.** Once implemented:
   - Update the canonical current-state spec(s) so they describe the new behavior as if it had always been there.
   - Move the proposal file to `specs/proposals/done/`.
   - Add a short historical note at the top pointing readers to the canonical spec for current behavior. The `done/` copy is design history only — no one should implement from it again.
6. **Deprioritization.** If a proposal is paused or explicitly not being pursued, move it to `specs/proposals/deprioritized/`. Nothing in that folder is live.

---

## Rules for AI agents

1. **Suggest a proposal first** for large, architectural, or cross-cutting changes — before writing code.
2. **Check for overlap** before creating a new proposal; prefer extending an open one.
3. **Stop at the implementation gate.** If you've been editing a proposal and think it's ready to build, ask the human for explicit approval before touching source. Do not move directly from proposal edits to code edits.
4. **Treat `deprioritized/` as invisible.** Do not read, reference, summarize, or build on anything in that folder. Moving a proposal there is how the human takes it off the table.
5. **`done/` is frozen history.** Read it for context only. Never implement from it; the canonical spec is what the system actually does now.
6. **Absorb, then move.** When a proposal is implemented, update the canonical docs *and* move the file to `done/` in the same change. An implemented proposal still sitting in `specs/proposals/` is a stale invitation to re-do the work.

---

## Canonical spec

Every repo using this workflow **must maintain a canonical current-state spec** — a living design document describing what the system is today at a mid-to-high level. Typical contents:

- **Purpose / use cases** — what the system does and who uses it.
- **Domain** — core concepts, vocabulary, invariants.
- **Architecture** — components, boundaries, how they fit together. Mermaid diagrams encouraged.
- **Features** — capability-level description of what exists today.

Properties of the spec:

- **Living.** Updated every time a proposal is implemented, as part of the absorption step. A spec that hasn't changed in months while proposals have been merged is a bug.
- **Current-state only.** Describes what *is*, not what *will be*. Future state belongs in proposals, not here.
- **Mid-to-high level.** Architecture and domain, not line-level detail. API reference, code-level docs, and configuration tables belong in other files.
- **The source of truth.** When it disagrees with anything in `specs/proposals/done/`, the canonical spec wins. `done/` is frozen history; the spec is reality.

### Shape: single file or wiki

The canonical spec can take either shape:

1. **Single file** (default for small repos) — one markdown file covering everything. Simpler, fewer decisions about where a fact belongs.
2. **Wiki of cross-linked files** (for larger or concept-dense repos) — a top-level index page + topic pages, all cross-linked, weaving into a cohesive whole. An Obsidian-style "second brain" for the project. The whole set collectively is the canonical spec: any page in it wins over `done/`.

**Grow into the wiki, don't scaffold it.** Start with the single file. Extract a new page when one of these is true:

- **Size.** A section fills more than a screen, or sprouts its own multi-level subsections that obscure the parent.
- **Prominent concept.** A domain concept is referenced widely across the spec, is non-generic (specific to this system, not a common term), and non-trivial (worth more than a sentence to explain). These deserve their own page even if the section describing them in the main spec is small — so other pages can link *to the concept* rather than each re-explaining it.

When extracting, replace the removed content in the index with a short summary paragraph and a link to the new page.

### Links

Use **standard markdown relative links** (`[term](./accounts.md)`), not Obsidian-style `[[wikilinks]]`. Standard links work in Obsidian, GitHub, `gh`, and every other renderer; wikilinks only render well inside Obsidian. You get the same cross-linking benefit without locking the repo to a specific tool.

Cross-link generously. Each time a sub-page mentions a concept that has its own page, link to it. The density of the link graph is what makes the wiki work as a second brain.

### Location and entry point

Location is repo-specific (`specs/<system>.md`, `docs/architecture.md`, etc.). Whatever the path, `CLAUDE.md` must reference the **entry point** — the single file (for single-file shape) or the index page (for wiki shape) — so every session finds it. The entry point is responsible for linking to all sub-pages; nothing in the wiki should be reachable only via filesystem listing.

---

## Named workflows

These are the core verbs the human uses to drive a proposal through its lifecycle. The human invokes them by name (e.g. "sharpen this proposal", "implement the foo proposal"). Each workflow has a clear start, end, and pause points.

### Draft a proposal

**Input:** a short description from the human of what they want.

**Goal:** produce a new proposal file in `specs/proposals/` that's a solid first draft — not sharpened yet, but coherent and covering the expected sections.

**Steps:**
1. **Clarify scope.** Ask the human as many clarifying questions as genuinely needed to understand *what* is being proposed and *why now*. Don't guess on anything material. Questions usually cover: problem being solved, rough scope boundaries, hard constraints, preferred technology, non-goals, who/what consumes the output.
2. **Check for overlap** with existing open proposals before creating a new file. If overlap is substantial, suggest extending the existing proposal instead.
3. **Draft the file** under `specs/proposals/<slug>.md` using the format above (Title / Status=Draft / Last updated / Problem / Scope / Design / Implementation notes / Open questions). It's fine — expected, even — for the draft to have open questions; those are the seed for the next step.
4. **Stop.** Surface the draft to the human and ask whether to proceed to sharpening.

### Sharpen a proposal

**Input:** an existing proposal file.

**Goal:** drive the proposal to a state where it can be implemented as-is by the AI without further major decisions.

**Steps:**
1. **Deep review.** Read the proposal end-to-end. Hunt for:
   - Open issues (things the proposal hand-waves, leaves TBD, or implies without specifying).
   - Internal contradictions (two sections that disagree, or a design that doesn't satisfy its stated goals).
   - Unwarranted assumptions (facts asserted without evidence, especially about behavior of dependencies or existing code — verify against the repo when feasible).
   - Missing tradeoffs (a choice is made but alternatives aren't acknowledged).
   - Unclear boundaries (scope creep, unclear non-goals, undefined interfaces).
   - Size risk (is this too big to implement in a single session? If so, suggest running **split the proposal** before continuing).
2. **Post the list** to the human as a numbered set of questions, each phrased so it has a clear resolution.
3. **Add the list to the proposal** as an `Open questions (sharpening)` checklist section. This makes progress visible in the file itself.
4. **Work through items one by one**, together with the human:
   - For each item, propose options with tradeoffs. Recommend one when you have a clear view, but let the human redirect.
   - When resolved, update the relevant section(s) of the proposal to reflect the decision, then tick the item off the sharpening checklist.
   - Don't batch decisions silently — each resolution is a visible edit.
5. **Re-review** after items are resolved. Sharpening often surfaces new questions downstream of earlier decisions; add those to the checklist and keep going.
6. **Completion.** The proposal is fully sharpened when:
   - The sharpening checklist is empty (or holds only intentionally-deferred items, explicitly marked).
   - Re-reading the proposal, you can identify no major question that would block implementation.
   - You would feel comfortable implementing it as-is without further input.
7. **Stop.** Report sharpened status to the human. Suggest running **split the proposal** if the scope still looks too big for one session.

### Split the proposal

**Input:** a proposal (sharpened or not) that feels large.

**Goal:** break the proposal into **stages** that can be delivered and tested independently — or recognize that the parts actually belong in separate proposals.

**Steps:**
1. **Review the proposal** and identify natural seams. A seam is a point where you could stop, ship, run tests, and have something that works and adds value on its own.
2. **Propose stages.** For each stage, specify:
   - A short name.
   - What it delivers (the user-visible or system-visible change).
   - How it's independently testable (what quality gates verify it).
   - Dependencies on prior stages.
3. **Decide: stages or separate proposals?** If the proposed chunks share a design thread and build on each other, they're stages of one proposal — add a `Stages` section to the proposal and list them. If the chunks have little to do with each other beyond being adjacent in time, suggest promoting them to separate proposals instead.
4. **Update the file** with the chosen stage breakdown (or spawn new proposal files for the split-out pieces).
5. **Stop** and confirm the split with the human before further work.

### Implement a proposal

**Input:** a proposal, ideally sharpened and split.

**Goal:** land the code change and bring the proposal to `Implemented`.

**Steps:**
1. **Pre-flight sharpening check.** Re-read the proposal with an implementer's eye. Classify any remaining questions:
   - **Significant** (would change design or force a non-obvious choice mid-code): **stop** and run **sharpen a proposal** instead. Do not start coding.
   - **Trivial** (a naming call, a small library choice, a formatting decision): list them with suggested options, ask the human to accept, and proceed once they do.
2. **Stage loop.** For each stage in order:
   1. Implement the stage.
   2. Run all relevant quality gates: typecheck, linter, unit tests, integration tests, end-to-end tests that apply to the stage. Fix anything broken — don't hand back a red build.
   3. If a **significant open question** surfaces mid-implementation (something the proposal didn't anticipate that would change design), **pause and ask** before proceeding.
   4. Commit and push the relevant files for this stage. Commit message should reference the proposal and the stage.
   5. Update the proposal's `Status` / stage checklist to reflect completion.
   6. **Pause.** Print a summary of ≤4 paragraphs covering: what was built, important choices made, anything surprising or worth flagging, what's next.
   7. Wait for the human to say "continue" (or equivalent) before starting the next stage.
3. **Final stage.** After the last stage, follow the absorption step from the lifecycle: update the canonical current-state spec(s), add a historical note to the proposal pointing to where current behavior now lives, and move the file to `specs/proposals/done/`. Commit and push that alongside the final stage.
