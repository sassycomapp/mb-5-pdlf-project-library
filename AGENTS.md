# AGENTS.md — project-library [mb5pdlf]

## Project purpose
This is the planning, documentation, and specification repository for the MB5 PDLF
test project (mb5pdlf). It is not the live code repository.

This project exists to test the pdlf (BODY-PDLF) development strategy end-to-end
before applying it to production projects. The app being built (a Daily Intentions
Tracker) is deliberately small so the full 17-stage pipeline can run in a few sessions.

Its purpose is to:
- test whether pdlf's 17-stage pipeline feels natural or forced for a small project,
- test whether BFT checkpoints add value or just add overhead,
- test whether the ISA is a useful artifact or just paperwork,
- test whether the single-step "continue" cadence keeps the developer engaged,
- test whether the LEARN junction at the end actually makes the next project easier,
- produce a working (if rough-edged) Daily Intentions Tracker app.

The live application code lives in `../mb5pdlf/`. Read from it for context when needed.
Do not treat this repo as the application implementation workspace.

## Hard rules (always apply)

### 1. anvil.yaml protection

Hard rule: never ever write to anvil.yaml.

- Treat anvil.yaml as Anvil-managed metadata/configuration.
- Do not create, edit, reformat, regenerate, normalize, merge-edit, or patch it.
- Do not include it in bulk refactors or automated file updates.
- If a task appears to require changing anvil.yaml, stop and ask the user for explicit approval.
- Assume Anvil is the authoritative writer for anvil.yaml.

### 2. Two-repo separation

- This repo (`project-library/`) = planning, docs, ADRs, wireframes, pdlf artifacts. Does NOT go to Anvil.
- Code repo (`../mb5pdlf/`) = live Anvil code + anvil.yaml. Goes to Anvil via GitHub VC.
- The agent writes to project-library freely. The agent writes to the code repo only during
  pdlf stages 14–16 (frontend assembly, feature development, integration) and only for code
  files — never anvil.yaml.

### 3. GBrain cross-contamination discipline

GBrain stores pages from multiple projects (mb-3-cs, mb4ecom, mb5pdlf, and others).
To prevent cross-project contamination:

- **When querying GBrain**, always tag every result with its source project.
- State explicitly: "this result is from project X — advisory, not canonical — confirm before applying."
- Cross-project **learnings** are welcome (a mistake in one project can inform another).
- Cross-project **decisions** (ADRs, ISAs, architecture) are NOT transferable unless the human
  explicitly confirms.
- When possible, scope queries using `--source mb5pdlf` to restrict results to this project.
- At Junction 0 (LEARN), query both this project's source AND the default source for prior
  learnings, but clearly separate "this project's prior art" from "other projects' learnings."

### 4. pdlf artifact routing

| Artifact | Destination |
|---|---|
| Devlog, ISA, BFT checkpoints | `pdlf/` |
| ADRs | `adr/` |
| Wireframes, mockups | `wireframes/` |
| Screen HTML mockups | `screens/` |
| Durable docs | `docs/` |
| WIP files | `wip/` |
| Pre-project first-thoughts | `pre-project/` |
| State file | `~/.gstack/projects/mb5pdlf/pdlf-state.md` |

### 5. Fact rule and certainty levels

- Do not use general training data or prior memory to assert project-specific facts.
- If a fact is not supported by files in this repo or the code repo, treat it as inferred or missing.
- Every statement must fall into one of: Clearly defined, Partially defined, Inferred only, Missing.
- Do not upgrade inferred material to clearly defined.

### 6. pdlf test honesty

This is a test project. Honesty about the pdlf process matters more than shipping a product:

- If a pdlf stage feels like waste, say so in the devlog.
- If BFT checkpoints feel like overhead, say so in the devlog.
- If the ISA feels like paperwork, say so in the devlog.
- The LEARN junction (stage 17b) must include an honest assessment of whether pdlf added value.

## Workspace structure

| Folder | Purpose |
|---|---|
| `pre-project/` | Developer's first-thoughts, scoping ideas, ideation notes (input to pdlf) |
| `pdlf/` | pdlf orchestrator artifacts: devlog, ISA, BFT checkpoints |
| `pdlf/bft/` | BFT checkpoint output files per stage |
| `adr/` | Architecture Decision Records — one decision per file |
| `docs/` | Durable application documentation, specs, UI standards, DESIGN.md |
| `wireframes/` | HTML wireframes, mockups, and visual layout references |
| `screens/` | Screen HTML mockups and their compliance checklists |
| `wip/` | Active work-in-progress: current plans, prompts, and files being prepared |

## pdlf workflow

This project is managed using pdlf — a contiguous, stage-gated, memory-compounding
development strategy. Type `/pdlf` in OpenCode to init or resume.

- **pdlf home:** `C:\pdlf\` (skill, templates, registry — shared across all projects)
- **State file:** `~/.gstack/projects/mb5pdlf/pdlf-state.md` (machine resume token)
- **Devlog:** `pdlf/devlog.md` (human append-only audit trail)
- **ISA:** `pdlf/isa.md` (living done-definition)
- **GBrain source:** `mb5pdlf` (isolated — scoped queries only)
- **Anvil app slug:** `mb5pdlf`

## Safety rules

- Do not create, edit, move, or delete files unless the user clearly asks for that operation.
- Never run destructive operations without a clear warning and explicit confirmation.
- Prefer proposing diffs or patches in chat over auto-applying changes.
- Git operations are permission-only.
- Do not push, publish, sync, or export anything unless the user explicitly asks.

## Communication style

- Keep answers concise, structured, and practical.
- Distinguish clearly between facts from the repo, inferences, and proposed revisions.
- Flag uncertainty, contradictions, or missing provenance explicitly.

## Agent skills

### Issue tracker

Local markdown — issues live as files under `.scratch/<feature>/` in this repo. See `docs/agents/issue-tracker.md`.

### Triage labels

Five canonical labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix` (defaults). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context — `CONTEXT.md` at repo root + `adr/` for architectural decisions. Two-repo architecture: this repo holds planning/docs, `mb5pdlf` holds app code (Daily Intentions Tracker). PDLF test project. See `docs/agents/domain.md`.
