# MB5 BDLF — Project Library

Planning, documentation, and specification repository for the MB5 BDLF test project.

This project exists to test the bdlf (BODY-PDLF) development strategy end-to-end
before applying it to production projects.

## Structure

| Folder | Purpose |
|---|---|
| `pre-project/` | Developer's first-thoughts, scoping ideas, ideation notes (input to bdlf) |
| `bdlf/` | bdlf orchestrator artifacts: devlog, ISA, BFT checkpoints |
| `bdlf/bft/` | BFT checkpoint output files per stage |
| `adr/` | Architecture Decision Records |
| `docs/` | Durable application documentation and specifications |
| `wireframes/` | HTML wireframes, mockups, visual layout references |
| `screens/` | Screen HTML mockups and compliance checklists |
| `wip/` | Active work-in-progress |

## bdlf

This project is managed using bdlf — a contiguous, stage-gated, memory-compounding
development strategy. Type `/bdlf` in OpenCode to init or resume.

**Code repo:** `../mb5bdlf/` (Anvil-connected, GitHub VC)
**State file:** `~/.gstack/projects/mb5bdlf/bdlf-state.md`
**Anvil app slug:** `mb5bdlf`
