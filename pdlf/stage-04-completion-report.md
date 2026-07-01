# Stage 4 Completion Report — Concept Definition

**Project:** mb5pdlf
**Stage:** 4 — Concept Definition
**PDLF Phase:** A (Discover)
**Date:** 2026-06-30
**Duration:** 1 session
**Status:** Complete

## 1. Purpose
Identify the essential working principle — what the concept actually is. Per PDLF, this stage uses first-principles thinking, abstraction, concept modeling, and requirements reasoning to find the irreducible core of the concept.

## 2. Inputs
- `pdlf/stage-03-expanded-concept-model.md` — 6-section expansion with 9 boundary questions
- 4 boundary questions assigned to stage 4: editable morning intentions?, three fixed vs. adjustable?, reflection required/optional?, skip-a-day?
- 1 boundary question moved from stage 10: one table vs. two tables
- `pdlf/stage-02-concept-statement.md` — the 5 pillars and concept paragraph
- `adr/001-cross-project-anvil-knowledge-reuse.md` — cross-project advisory context

## 3. Work performed

### 3.1 Essential working principle identification
Stripped the concept to its irreducible core through first-principles reasoning:

> The app converts the act of daily intention-setting from a fleeting thought into a committed, irreversible record.

Identified four implications: (1) commitment is the value, (2) the record is the product, (3) honesty is structural not motivational, (4) friction is the feature not the bug.

### 3.2 Boundary question resolutions (5 decisions)
Resolved all 5 boundary questions assigned to this stage using first-principles reasoning derived from the essential working principle:

| Question | Resolution | First-principles basis |
|---|---|---|
| Editable morning intentions? | **NO** — not editable after first save | Commitment requires irreversibility; editable = draft, not commitment |
| Three fixed vs. adjustable? | **THREE FIXED** | Forces prioritisation; adjustable dilutes commitment |
| Reflection required or optional? | **OPTIONAL** | Required reflection is homework, not honesty; friction threatens the 60-second goal |
| Skip-a-day? | **NO SKIP** | A gap in history IS the record; skip adds a third state to a binary system |
| One table or two? | **ONE TABLE** | Three fixed intentions = fixed schema; two-table is normalisation for flexibility the concept rejects |

### 3.3 Concept definition produced
Consolidated all decisions into a single precise definition paragraph (section 3 of the stage output). This paragraph is the concept-level truth — changing any element makes it a different app.

### 3.4 Deferred implementation decisions identified
Separated concept-level decisions from implementation decisions. 6 items deferred to stages 8 and 13 (M3 component choices, lock enforcement, logic module pattern, CSS overlay, routing).

## 4. Outputs (artifacts produced)

| Artifact | Path | Description |
|---|---|---|
| Core concept definition | `pdlf/stage-04-core-concept-definition.md` | Essential working principle + 5 boundary resolutions + full concept definition + deferred items |
| Devlog entry 6 | `pdlf/devlog.md` | Stage 4 entry |
| State file | `~/.gstack/projects/mb5pdlf/pdlf-state.md` | Updated: stage 4, substep "definition-complete" |

## 5. Decisions made

| Decision | Rationale | Deferred to ADR? |
|---|---|---|
| Intentions are NOT editable after first save | Essential working principle: commitment requires irreversibility | No — concept decision |
| Three fixed intentions (not adjustable) | Forces prioritisation; adjustable dilutes commitment | No — concept decision |
| Reflection is optional | Required reflection is friction without structural value | No — concept decision |
| No skip-a-day feature | A gap in history is the record; skip adds complexity without value | No — concept decision |
| One table (single `intentions` table) | Three fixed = fixed schema; two-table is for flexibility the concept rejects | No — concept decision |
| `user_id` column added (nullable), no `users` table at v1 | Future-proof per constraints; `users` table would imply auth | No — concept decision |

## 6. Open questions resolved this stage

| Question | Resolution |
|---|---|
| #1: Are morning intentions editable before evening review? | No — not editable after first save |
| #2 (full): Past days editable within same day or until midnight? | Not editable at all after first save. Lock at client-side midnight is additional protection. |
| #5: Should there be a way to skip a day intentionally? | No — a gap in history is the record |
| #6 (concept-level): Is the one-table schema right? | Yes — three fixed intentions = single table |

## 7. Open questions still deferred

| Question | Deferred to stage | Current leaning |
|---|---|---|
| Morning/evening detection: server-side or client-side implementation? | Stage 8 | Leaning: server checks if record exists for today's date |
| Switch or checkbox for done toggle? | Stage 13 | Leaning: `m3.Switch` |
| DataGrid or RepeatingPanel for history? | Stage 13 | Leaning: `RepeatingPanel` + `m3.Card` |
| Pure logic modules vs inline logic? | Stage 8 | Leaning: pure logic modules (mb-3-cs advisory) |
| Anvil routing vs startup redirect? | Stage 8 | Leaning: startup redirect |

## 8. BFT checkpoint summary
- Bones: big bones = 5 boundary resolutions. Key-type = essential working principle ("committed, irreversible record").
- Muscle: logic muscle (first-principles reasoning for each decision). No emotional/habit/channel muscle — decisions derived from principle, not preference.
- Nerves: Analyzing network (top-down decomposition into essential vs. implementation).
- Fat: minimal — each section serves the definition. Scenario illustrations kept because they justify decisions.
- Skin: single dense definition paragraph. Tree structure: principle → resolutions → definition → deferred.
- Health: good — specific, testable, internally consistent. Every resolution traces to the essential working principle. Scope is tight.

## 9. Gate status
No gate — next gate at stage 5 (stage-5-distilled).

## 10. Next stage
Stage 5 (Concept Distillation) will remove fluff, assumptions, duplication, and non-essential details from the accumulated concept material (stages 1–4). Keep only truth, constraints, and relevance. The output is a distilled concept document — the minimal form of the concept that will feed into stage 6 (Project Framing). This is also the first gate (stage-5-distilled).

## 11. Maintenance performed
No maintenance run — stage 4 produces planning artifacts only. Maintenance will run at end of stage 5 (gate: stage-5-distilled) per section 6.4.
