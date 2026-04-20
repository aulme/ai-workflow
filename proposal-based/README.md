# Proposal-Based Workflow

A Claude Code workflow for designing non-trivial changes in prose before coding. Install the named-workflow skills (`/draft-proposal`, `/sharpen-proposal`, `/split-proposal`, `/implement-proposal`) via the repo-level [`install.sh`](../install.sh).

## Why

Large or architectural changes deserve a written artifact so humans and Claude argue about the **design in prose**, not after the fact in diffs. Proposals leave an auditable trail of *why* the code looks the way it does.

## Directory layout

```
specs/proposals/                 # open (unimplemented)
specs/proposals/done/            # implemented — design history only
specs/proposals/deprioritized/   # paused or won't-do — invisible to Claude
```

Every repo using this workflow also maintains a **canonical current-state spec** (see below). Proposals describe changes *to* that spec.

## When to write a proposal

Write or extend one when the change is:

- Architectural or cross-cutting (spans multiple components/layers).
- A new subsystem, data model, or external integration.
- A multi-step migration.
- A design decision with real tradeoffs worth naming.

Skip for small bug fixes, local refactors, and obvious additions with a single reasonable design.

Before drafting, scan `specs/proposals/` for overlap — prefer extending an open proposal.

## Proposal format

Single markdown file with:

- **Title**
- **Status** — `Draft` / `Accepted` / `In Progress` / `Implemented` / `Future` / `Deprioritized`
- **Last updated** — ISO date
- **Problem** — what's broken, missing, or painful
- **Scope / goals** — what's in, what's explicitly out
- **Design** — concrete enough to implement from
- **Implementation / migration notes** — order of delivery
- **Open questions** (optional)

Mermaid for diagrams. No ASCII art.

## Lifecycle

1. **Draft** — create `specs/proposals/<slug>.md` after an overlap check.
2. **Active** — edit in place while the human is engaged.
3. **Implementation gate** — before *any* source edit driven by this proposal, stop and ask. No silent jump from prose to code.
4. **Implement** — code lands; `Status` moves `In Progress` → `Implemented`.
5. **Absorb** — in a single change: update the canonical spec(s) to describe the new behavior as current, add a one-line "absorbed into <link>" note at the top of the proposal, move it to `done/`.
6. **Deprioritize** — paused or cancelled proposals move to `deprioritized/`.

## Rules

1. **Suggest a proposal first** for any change meeting the "when to write" criteria — before touching code.
2. **Check for overlap** before creating a new file; extend an existing proposal when possible.
3. **Stop at the implementation gate.** Explicit human approval required to move from proposal edits to source edits.
4. **Treat `deprioritized/` as invisible.** Do not read, cite, summarize, or build on anything in it.
5. **Treat `done/` as frozen history.** Context only; never implement from it. The canonical spec is what the system *is*.
6. **Absorb and move in one change.** An implemented proposal still sitting in `specs/proposals/` is a stale invitation to redo the work.

## Canonical spec

A living design document describing what the system *is today* at a mid-to-high level.

**Contents:** purpose / use cases · domain (concepts, vocabulary, invariants) · architecture (components, boundaries, diagrams) · features (capabilities that exist).

**Properties:**

- **Living** — updated on every proposal absorption.
- **Current-state only** — future work lives in proposals, not here.
- **Mid-to-high level** — not API reference, not config tables.
- **Source of truth** — when it disagrees with `done/`, the spec wins.

### Shape: single file → wiki

Start as one file. Extract a sub-page when either holds:

- **Size** — a section outgrows a screen or sprouts subsections that obscure the parent.
- **Prominent concept** — referenced widely, non-generic (specific to this system), non-trivial (more than a sentence to explain). Deserves its own page so others link *to the concept*.

On extract, leave a one-paragraph summary and a link where the content was.

Use **standard markdown relative links** (`[x](./x.md)`), not `[[wikilinks]]`. Cross-link generously; link-graph density is what turns the wiki into a second brain.

### Entry point

Path is repo-specific. `CLAUDE.md` must link the canonical spec's entry point — the single file or the wiki index — so every session finds it. The entry point links to everything else.

## Named workflows

When the human invokes one of these verbs, load and execute the linked procedure (or call the slash command if skills are installed):

- **draft a proposal** — [`draft.md`](./draft.md) — `/draft-proposal`
- **sharpen a proposal** — [`sharpen.md`](./sharpen.md) — `/sharpen-proposal`
- **split the proposal** — [`split.md`](./split.md) — `/split-proposal`
- **implement a proposal** — [`implement.md`](./implement.md) — `/implement-proposal`
