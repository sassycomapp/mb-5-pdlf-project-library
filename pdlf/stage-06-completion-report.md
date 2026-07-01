# Stage 6 Completion Report — Project Framing

**Project:** mb5pdlf
**Stage:** 6 — Project Framing
**PDLF Phase:** B (Define) — first stage
**Date:** 2026-06-30
**Duration:** 1 session
**Status:** Complete

## 1. Purpose
Convert the distilled concept (stage 5) into operational form: goals, user flows, workflows, scope, outcomes. Output: Project Concept Document (PCD). Per PDLF, this stage uses user flow design, operational workflow design, use cases, and journey mapping.

## 2. Inputs
- `pdlf/stage-05-distilled-concept-document.md` — 9-section distilled concept (the reference for Phase B)
- `adr/001-cross-project-anvil-knowledge-reuse.md` — cross-project advisory
- Open question #4 (first-time-at-3pm) — assigned to stage 6

## 3. Work performed

### 3.1 Goal decomposition
Decomposed the overall objective ("ship a deployable v1 of the Daily Intentions Tracker in a few focused sessions as a PDLF test") into 9 sub-objectives spanning stages 8–17b. Identified parallel objectives: ship a working app AND test whether PDLF adds value.

### 3.2 User flow design
Designed 5 user flows:
1. Morning — set intentions (no record → 3 text areas → save → irrevocable)
2. Evening — review intentions (record exists, not locked → 3 read-only + 3 toggles + reflection → save)
3. Locked day (record exists, locked → read-only with message)
4. History (scrollable list, gaps visible, no filter/search)
5. First-time use (identical to Flow 1 — no onboarding)

All flows derive from the state-based detection model established in stage 3.

### 3.3 Server workflow design
Designed 5 server-side workflows (Python pseudocode, not implementation):
- `get_today_state()` — returns morning/evening/locked state
- `set_intentions()` — creates today's record (rejects if exists — irrevocable)
- `save_review()` — updates today's record with done states + reflection
- `check_and_lock_past_days()` — locks records where date < today
- `get_history()` — returns all records descending by date

### 3.4 Scope definition
Defined in-scope (12 items), out-of-scope (13 items), and future (5 items). The scope is tight: one table, two screens, no auth, no extras, MD3 native only.

### 3.5 Success criteria and ISC candidates
Defined 7 success criteria with verification methods. Mapped 6 ISC candidates that will become the ISA's Ideal State Criteria at stage 12.

### 3.6 Open question resolved
Confirmed open question #4 (first-time-at-3pm): state-based detection handles it. No additional design needed.

## 4. Outputs (artifacts produced)

| Artifact | Path | Description |
|---|---|---|
| Project Concept Document (PCD) | `pdlf/stage-06-project-concept-document.md` | Goals, 5 user flows, 5 server workflows, scope, success criteria, ISC candidates |
| Devlog entry 8 | `pdlf/devlog.md` | Stage 6 entry |
| State file | `~/.gstack/projects/mb5pdlf/pdlf-state.md` | Updated: stage 6, substep "framing-complete" |

## 5. Decisions made

| Decision | Rationale | Deferred to ADR? |
|---|---|---|
| 5 user flows defined (not more, not fewer) | Covers all interaction states: morning, evening, locked, history, first-time. No onboarding flow needed. | No — operational decision |
| 5 server workflows with pseudocode | Pseudocode clarifies logic without committing to implementation. Actual Python at stage 15. | No |
| 6 ISC candidates identified | Will become the ISA's verification items at stage 12. Listed as candidates, not locked. | No |
| First-time-at-3pm confirmed resolved | State-based detection from stage 3 handles it. No additional design. | No |

## 6. Open questions resolved this stage

| Question | Resolution |
|---|---|
| #4 (full): What happens if user opens app for first time at 3pm? | Morning mode (no record exists). State-based detection handles it. Confirmed. |

## 7. Open questions still deferred

| Question | Deferred to stage | Leaning |
|---|---|---|
| Lock enforcement: server-side or client-side implementation? | 8 | Client-side date comparison |
| Pure logic modules vs inline logic? | 8 | Pure logic modules (advisory) |
| Anvil routing vs startup redirect? | 8 | Startup redirect |
| `m3.Switch` vs `m3.Checkbox` for done toggle? | 13 | `m3.Switch` |
| `RepeatingPanel`+`m3.Card` vs `DataGrid` for history? | 13 | `RepeatingPanel` + `m3.Card` |

## 8. BFT checkpoint summary
- Bones: big bones = 5 user flows, 5 server workflows, scope table, success criteria. Key-type = state-based detection (determines startup flow).
- Muscle: purpose (overall → 9 sub-objectives) + information (distilled concept) + logic (flows derived from concept decisions).
- Nerves: Achieving network (purpose → sub-objectives → means → detail).
- Fat: server pseudocode is muscle (clarifies logic), not fat. Cut: API design, deployment details, test strategy.
- Skin: 6-section PCD. Tree structure: goals → flows → workflows → scope → outcomes.
- Health: good — operational, specific, testable. Every flow traces to a concept decision. ISC candidates ready for stage 12.

## 9. Gate status
No gate — next gate at stage 12 (stage-12-locked).

## 10. Next stage
Stage 7 (Platform & Framework Selection) — define execution environment and foundational stack. Per the distilled concept, the platform is already constrained: Anvil.works + MD3 + Anvil Data Tables. Stage 7 will confirm these, document the stack, and apply ADR-001 cross-project advisory for the first time at the platform level.

## 11. Maintenance performed
No maintenance run — stage 6 produces planning artifacts only. Next maintenance at end of stage 8 (architecture decisions) per section 6.4.
