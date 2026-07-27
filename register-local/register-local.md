---
document: Register — mb5pdlf-project-library
doc-id: mb5pdlf-0013
state: Live
date-created: 2026-07-25T215540+0200
---

# Register — mb5pdlf-project-library

Append-only. Rows are never deleted. Only `state`, `date-state-changed`,
`superseded-by`, and `notes` may be updated in place after a row is created.
All other fields are permanent from first registration.

| doc-id | filename | folder | type | state | date-registered | date-state-changed | superseded-by | notes |
|---|---|---|---|---|---|---|---|---|
| mb5pdlf-0001 | AGENTS.md | . | guide | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0002 | README.md | . | guide | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0004 | adr/001-cross-project-anvil-knowledge-reuse.md | adr | adr | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0005 | adr/002-pure-logic-module-architecture.md | adr | adr | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0006 | adr/003-lock-enforcement-strategy.md | adr | adr | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0007 | docs/agents/domain.md | docs/agents | guide | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0008 | docs/agents/issue-tracker.md | docs/agents | guide | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0009 | docs/agents/triage-labels.md | docs/agents | guide | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0010 | pre-project/01-project-brief.md | pre-project | other | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0011 | pre-project/02-scoping-ideas.md | pre-project | other | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |
| mb5pdlf-0012 | pre-project/03-constraints-and-notes.md | pre-project | other | Live | 2026-07-27T124852+0200 | 2026-07-27T124852+0200 | | |

## Field definitions

- **doc-id** — permanent identifier, assigned at first registration, never reused even if the row's state becomes Retired.
- **filename** — current registered name of the document.
- **folder** — folder within the corpus this document lives in.
- **type** — document type (adr / spec / policy / guide / checklist / sop / template / other).
- **state** — one of: `Live`, `Retired`, `Quarantine`. Mirrors the document's own front-matter `state` field.
- **date-registered** — date this row was first appended. Never changes. Format: `YYYY-MM-DDTHHMMSS+0200`, per `global-0037`.
- **date-state-changed** — date `state` last changed. Updated whenever state flips. Same format as date-registered.
- **superseded-by** — doc-id of the version that replaced this one, if state is Retired due to versioning. Blank otherwise.
- **notes** — free text, optional.
