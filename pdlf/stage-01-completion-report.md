# Stage 1 Completion Report — Ideation

**Project:** mb5pdlf
**Stage:** 1 — Ideation
**PDLF Phase:** A (Discover)
**Date:** 2026-06-30
**Duration:** 1 session
**Status:** Complete

## 1. Purpose
Generate many possible ideas and opportunities from the pre-project sources. Output: an idea pool. Per PDLF, ideation is broad, unfiltered, and deliberately messy — the filter comes at stage 5 (Distillation).

## 2. Inputs
- `pre-project/01-project-brief.md` — project brief for a Daily Intentions Tracker
- `pre-project/02-scoping-ideas.md` — 14 feature ideas, data model sketch, UI sketch, tech sketch
- `pre-project/03-constraints-and-notes.md` — 6 hard constraints, 3 soft constraints, 6 open questions
- Junction 0 prior context brief — cross-project advisory from mb-3-cs (Anvil specs, ADR-034, screen production reports)
- User architectural decision: create ADR for cross-project Anvil knowledge reuse

## 3. Work performed

### 3.1 Pre-project source analysis
Read all three pre-project documents. Extracted:
- Core concept: a small web app for setting 1–3 daily intentions in the morning and marking them done/not-done in the evening
- Platform: Anvil.works with Material Design 3
- Constraints: single user for v1, one table, mobile-first, no external APIs, fast timeline
- 14 raw feature ideas from the scoping doc
- 6 open questions tagged to specific PDLF stages

### 3.2 Cross-project knowledge integration
Queried mb-3-cs GBrain sources (advisory, per ADR-001) for Anvil proprietary knowledge. Identified three advisory patterns:
- Pure logic modules (from mb-3-cs `docs/architecture.md`) — testable server-side business logic
- M3 native components only (from mb-3-cs `docs/ui-standards.md`) — no mixing with non-M3
- Anvil Extras exclusion (from mb-3-cs `adr/14-anvil-extras-exclusion.md`) — never used

These are advisory for stage 8, not adopted yet.

### 3.3 ADR-001 creation
Created `adr/001-cross-project-anvil-knowledge-reuse.md` per the user's architectural decision. The ADR records:
- Decision to reference mb-3-cs `docs/` and `adr/` at stages 8, 10, 13, 14
- Specific source documents to research at each stage
- Cross-contamination discipline: all mb-3-cs knowledge is advisory, not canonical

### 3.4 Idea pool generation
Generated 37 ideas, tagged by source:
- 23 core ideas (carried forward to stage 2)
- 7 ideas explicitly rejected (streaks, categories, sharing, weekly review, reminders, analytics, settings)
- 3 cross-project advisory ideas (pure logic modules, M3 native only, Anvil Extras exclusion)
- 6 open questions deferred to later stages (reflection required?, past-day edit window?, morning/evening detection location?, first-time-at-3pm?, skip-a-day?, one-table vs two-table?)

## 4. Outputs (artifacts produced)

| Artifact | Path | Description |
|---|---|---|
| Idea pool | `pdlf/stage-01-idea-pool.md` | 37 ideas with source tags, categorized as core/rejected/advisory |
| ADR-001 | `adr/001-cross-project-anvil-knowledge-reuse.md` | Decision to reference mb-3-cs Anvil knowledge at appropriate stages |
| Devlog entry 3 | `pdlf/devlog.md` | Stage 1 entry with BFT checkpoint |
| State file | `~/.gstack/projects/mb5pdlf/pdlf-state.md` | Updated: stage 1, substep "ideation-complete" |

## 5. Decisions made

| Decision | Rationale | Deferred to ADR? |
|---|---|---|
| Cross-project Anvil knowledge is advisory, not canonical | mb-3-cs is a CRM; mb5pdlf is a tracker. Patterns may transfer, decisions don't. | Yes — ADR-001 created |
| 7 ideas explicitly rejected at ideation | User pre-rejected these in the scoping doc — listed for the record | No |
| 6 open questions deferred to stages 4, 6, 8, 10 | Questions belong to specific PDLF stages per the constraints doc | No |

## 6. Open questions deferred

| Question | Deferred to stage | Reason |
|---|---|---|
| Should the reflection field be required or optional? | Stage 4 (Concept Definition) | Concept definition decision |
| Should past days be editable within the same day only, or until midnight? | Stage 8 (Architecture) | Architecture decision |
| Should morning/evening detection be server-side or client-side? | Stage 8 (Architecture) | Architecture decision |
| What happens if the user opens the app for the first time at 3pm? | Stage 6 (Project Framing) | Framing decision |
| Should there be a way to skip a day intentionally? | Stage 4 (Concept Definition) | Concept definition decision |
| Is the one-table schema right, or should intentions be a separate table? | Stage 10 (Data Design) | Data design decision |

## 7. BFT checkpoint summary
- Bones: big bones = core concept (daily intentions tracker) + platform (Anvil + MD3) + constraints (single user, one table, fast). Key-type bone = two-pass daily structure (morning + evening) — the whole app hinges on this.
- Muscle: information muscle (pre-project docs + GBrain cross-project advisory). No logic/emotional muscle — this is ideation.
- Nerves: Exploring network (bottom-up expansion tree from pre-project sources).
- Fat: 7 ideas explicitly rejected. 1 deferred (markdown export).
- Skin: numbered list with source tags. Necklace structure. Up-front summary.
- Health: good in itself — broad enough for synthesis. Good for project — scope right for fast test. Open questions correctly deferred.

## 8. Gate status
No gate — next gate at stage 5 (stage-5-distilled).

## 9. Next stage
Stage 2 (Concept Synthesis) will combine, select, and consolidate the 23 core ideas into one candidate concept statement. Inputs: the idea pool, the ADR-001 cross-project advisory, and the 6 deferred open questions. The concept statement should be a single clear statement of what the app is.

## 10. Maintenance performed
No maintenance run — stage 1 produces planning artifacts only. First maintenance at end of stage 5 (gate: stage-5-distilled).
