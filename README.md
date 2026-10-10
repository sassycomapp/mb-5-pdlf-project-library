---
title: "README"
document: MB5 PDLF — Project Library
doc-id: "mb-8fdce0af"
updated: "2026-10-10"
state: Live
date-created: 2026-07-25T215540+0200
---

# MB5 PDLF — Project Library

Planning, documentation, and specification repository for the MB5 PDLF test project.

This project exists to test the pdlf (BODY-PDLF) development strategy end-to-end
before applying it to production projects.

## Structure

| Folder | Purpose |
|---|---|
| `pre-project/` | Developer's first-thoughts, scoping ideas, ideation notes (input to pdlf) |
| `pdlf/` | pdlf orchestrator artifacts: devlog, ISA, BFT checkpoints |
| `pdlf/bft/` | BFT checkpoint output files per stage |
| `adr/` | Architecture Decision Records |
| `docs/` | Durable application documentation and specifications |
| `wireframes/` | HTML wireframes, mockups, visual layout references |
| `screens/` | Screen HTML mockups and compliance checklists |
| `wip/` | Active work-in-progress |

## pdlf

This project is managed using pdlf — a contiguous, stage-gated, memory-compounding
development strategy. Type `/pdlf` in OpenCode to init or resume.

**Code repo:** `../mb5pdlf/` (Anvil-connected, GitHub VC)
**State file:** `~/.gstack/projects/mb5pdlf/pdlf-state.md`
**Anvil app slug:** `mb5pdlf`

## Status

**Placeholder.** mb5pdlf is the future test project for PDLF. It will be scoped around what those tests need, when they are needed. It is a live project: in scope, a registered GBrain source and GitHub repository, and on the commit-all list, although this library is still empty.
