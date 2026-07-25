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
| `output-gstack/` | GStack-produced reports |
| `output-opencode/` | OpenCode-produced reports |
| `output-matt-skills/` | Matt Pocock skill outputs |

---

## Artifact governance

Every artifact gets saved. Build actions only. Confirm save location.

| Producer | Destination |
|---|---|
| GStack | `output-gstack/` |
| OpenCode | `output-opencode/` |
| Matt Pocock skills | `output-matt-skills/` |

File type overrides: docs → `docs/`, ADRs → `adr/`, wireframes → `wireframes/`, screens → `screens/`, pdlf → `pdlf/`.

---

## Matt Pocock skills artifact governance

- `domain-modeling`, `grill-with-docs` → `CONTEXT.md` + `adr/`.
- `to-tickets`, `triage` → `.scratch/`.
- `setup-matt-pocock-skills` → `docs/agents/` + `AGENTS.md`.
- `handoff`, `improve-codebase-architecture` → `%TEMP%` + `output-matt-skills/`.
- `teach` → `C:\mybizz\matt-skills-teach`.
- Others → ask the user.

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

---

## Agent skills

### Issue tracker

GitHub Issues. See `docs/agents/issue-tracker.md`.

### Triage labels

Default labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context. See `docs/agents/domain.md`.

---

## Timestamp Standard

Every date or timestamp this agent generates for a build artefact — front matter, register entries, alignment logs, learnings entries, backup folder names, devlog entries, or any other system-internal record — must follow the format and conversion method defined in:

`C:\dev\project-library-global\adr-global\timezone-utc-storage-display-conversion.md`

This ADR specifies one mandatory method for generating the timestamp, with no fallback and no alternative. Read that document before generating any such timestamp. If anything about the required method is unclear, stop and ask the developer — do not improvise or substitute a different method.

This does not apply to client-facing data (bookings, invoices, activity logs, etc.), which follows the IANA-timezone-based rule in the same ADR's main Decision section, not this build-artefact standard.
