# AGENTS.md — project-library [mb5pdlf]

> Inherits Global `AGENTS.md` in full. This file adds project-specific rules only.

## Project purpose

Planning, documentation, and specification repository for the MB5 PDLF test project (mb5pdlf). Tests the pdlf pipeline end-to-end with a small Daily Intentions Tracker app. Not the live code repository. Live code lives in `../mb5pdlf/`.

---

## Definitions

- **project-library** — this repo. **mb5pdlf** — the separate live application code repo.

---

## Precedence order

1. Explicit user instruction → 2. Global `AGENTS.md` → 3. Hard Rules here → 4. ADRs → 5. Docs → 6. Skill defaults. Conflict = Default-to-Ask.

---

## Hard rules

### 1. anvil.yaml protection (enforced by opencode.json)
Never write to `anvil.yaml`.

### 2. Two-repo separation
- `project-library/` = planning, docs, ADRs, wireframes, pdlf artifacts. Not for Anvil.
- `../mb5pdlf/` = live Anvil code + `anvil.yaml`. Goes to Anvil via GitHub VC.
- Write to code repo only during pdlf stages 14–16, only code files, never `anvil.yaml`.

### 3. GBrain cross-contamination discipline
Tag every GBrain result with its source project. Cross-project decisions require explicit human confirmation. Scope queries with `--source mb5pdlf`.

### 4. No time-based references
Use Phase > Stage > Task > Sub-task hierarchy.

### 5. No hardcoded colors
Every color through CSS custom properties.

### 6. Plan reads, Build writes (enforced by opencode.json)
Plan never writes. Build writes only with user approval.

### 7. Skill ownership
Ask which skill before starting any task.

### 8. No deviation
Execute as specified. Propose deviations first.

### 9. Binding documents
ADRs, specs, rule files are binding. Check before starting.

### 10. pdlf test honesty
This is a test project. Honesty about pdlf matters more than shipping. If a stage feels like waste, say so in the devlog.

### 11. Mandatory project context reading
Read `README.md` before every task.

---

## Workspace structure

| Folder | Purpose |
|---|---|
| `pre-project/` | First-thoughts, scoping ideas |
| `pdlf/` | pdlf orchestrator artifacts: devlog, ISA, BFT |
| `adr/` | Architecture Decision Records |
| `docs/` | Durable documentation and specs |
| `wireframes/` | HTML wireframes and mockups |
| `screens/` | Screen HTML mockups |
| `wip/` | Active work-in-progress |
| `gstack-outputs/` | GStack-produced reports |
| `opencode-outputs/` | OpenCode-produced reports |
| `matt-skills-output/` | Matt Pocock skill outputs |

---

## Artifact governance

Every artifact gets saved. Build actions only. Confirm save location.

| Producer | Destination |
|---|---|
| GStack | `gstack-outputs/` |
| OpenCode | `opencode-outputs/` |
| Matt Pocock skills | `matt-skills-output/` |

File type overrides: docs → `docs/`, ADRs → `adr/`, wireframes → `wireframes/`, screens → `screens/`, pdlf → `pdlf/`.

---

## pdlf workflow

Managed using pdlf. Type `/pdlf` to init or resume.
- **pdlf home:** `C:\pdlf\`
- **State file:** `~/.gstack/projects/mb5pdlf/pdlf-state.md`
- **GBrain source:** `mb5pdlf` (isolated)

---

## Source of truth

- `project-library/adr/` — architectural decisions
- `project-library/docs/` — documentation and specs
- `mb5pdlf/` — live code (read-only context)

---

## Access model

- Plan: reads both repos. Never writes.
- Build: writes in `project-library` with approval. Writes in `mb5pdlf` only during coding phase with case-by-case permission.

---

## Task completion reporting

- Reports → producer's output folder.
- `devlog-index.md` — report index.
- `judgement-trail.md` — decisions per task.
- Scaffold exception: create headers if missing.
