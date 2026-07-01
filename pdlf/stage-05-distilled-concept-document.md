# Stage 5 Output — Distilled Concept Document

**Project:** mb5pdlf (Daily Intentions Tracker)
**Stage:** 5 — Concept Distillation
**Date:** 2026-06-30
**PDLF phase:** A (Discover) — final stage of Phase A

---

## Distillation method

Applied the BFT fat test to all material from stages 1–4:
1. Is it necessary? (Does removing it change the concept?)
2. Is it relevant? (Does it serve the essential working principle?)
3. Is it important? (Does it constrain or enable a later stage?)

Everything that failed all three tests was cut. Everything that passed at least one test was kept. The result is the minimal concept document — nothing that isn't truth, constraint, or relevance.

---

## Distilled concept document

### 1. Essential working principle

> The app converts the act of daily intention-setting from a fleeting thought into a committed, irreversible record.

### 2. What the app is

A single-user, mobile-first web application (Anvil.works + Material Design 3) that enforces a two-pass daily discipline cycle:

- **Morning:** user commits to exactly three free-text intentions. Upon save, intentions are **irrevocable** — not editable for the rest of the day.
- **Evening:** user marks each intention done or not-done. Optional one-line reflection. Upon save or client-side midnight, the record **locks** permanently.

### 3. Concept-level decisions (irreducible)

| Decision | Value | Basis |
|---|---|---|
| Intention count | Exactly 3, fixed | Forces prioritisation |
| Intention text | Free text, no categories/tags | Personal, daily, unstructured |
| Editability | Not editable after first save | Commitment requires irreversibility |
| Lock trigger | Client-side date change (midnight) | Single-user, no-auth, no timezone complexity |
| Morning/evening detection | State-based (morning = no record today; evening = record exists) | Intuitive, clock-independent |
| Reflection | Optional, one line | Required = homework, not honesty |
| Skip-a-day | No skip feature | A gap in history IS the record |
| Streaks/gamification/analytics | None | Honesty over optimisation |
| Reminders | None | If you need a reminder, the app failed |
| History | Scrollable list, no filter, no search, no charts | The record is the product |
| Settings/onboarding | None | First-time use = normal morning |
| Deletion | No UI deletion | Can't rewrite history |

### 4. Platform constraints (hard)

| Constraint | Value | Source |
|---|---|---|
| Platform | Anvil.works | Pre-project constraint |
| UI framework | Material Design 3 (dependency: 4UK6WHQ6UX7AKELK) | Pre-project constraint + ADR-001 |
| Data layer | Anvil Data Tables (single table) | Concept decision (three fixed = fixed schema) |
| External APIs | None | Pre-project constraint |
| Authentication | None for v1 | Pre-project constraint |
| Multi-tenancy | None for v1; `user_id` column (nullable) for future-proofing | Pre-project constraint |
| anvil.yaml | Never write to it | AGENTS.md hard rule |
| Timeline | Fast — few focused sessions | Pre-project constraint |

### 5. Data model (concept-level)

One table: `intentions`

| Column | Type | Notes |
|---|---|---|
| `date` | date | Unique — one record per day |
| `intention_1` | text | Free text, set in morning, not editable after save |
| `intention_2` | text | Same |
| `intention_3` | text | Same |
| `done_1` | bool | Default false; set in evening |
| `done_2` | bool | Same |
| `done_3` | bool | Same |
| `reflection` | text | Optional, one line, set in evening |
| `locked` | bool | Default false; set true at client-side midnight |
| `user_id` | text | Nullable; future-proofing, no auth implementation |
| `created_at` | datetime | Audit |
| `updated_at` | datetime | Audit |

No `users` table at v1 (would imply auth). No lookup tables, no junction tables.

### 6. Screen model (concept-level)

Two screens, plus a redirect:

1. **Today** — state-based: morning mode (3 empty text areas + save) or evening mode (3 read-only intentions + 3 done toggles + optional reflection + save). If locked: read-only with "This day is locked" message.
2. **History** — scrollable list of past days. Each entry: date, 3 intentions (strikethrough if done), reflection (if any). No filter, no search, no charts.
3. **Root** — redirects to Today.

### 7. Cross-project knowledge (advisory, per ADR-001)

mb-3-cs Anvil proprietary knowledge is advisory input for stages 8, 10, 13, 14. Three advisory patterns identified:
- Pure logic modules (no Anvil imports) for testable business logic — confirm at stage 8
- M3 native components only — confirm at stage 8
- Anvil Extras exclusion — confirm at stage 8

**Not canonical. Adoption requires explicit devlog note.**

### 8. Open questions deferred to later stages

| Question | Stage | Leaning |
|---|---|---|
| Lock enforcement: server-side or client-side implementation? | 8 | Client-side date comparison |
| Pure logic modules vs inline logic? | 8 | Pure logic modules (advisory) |
| Anvil routing vs startup redirect? | 8 | Startup redirect |
| `m3.Switch` vs `m3.Checkbox` for done toggle? | 13 | `m3.Switch` |
| `RepeatingPanel`+`m3.Card` vs `DataGrid` for history? | 13 | `RepeatingPanel` + `m3.Card` |

### 9. What was cut (fat removed during distillation)

| Material | Source stage | Why cut |
|---|---|---|
| 7 explicitly rejected feature ideas (streaks, categories, sharing, etc.) | Stage 1 | Already rejected — no need to carry the rejection forward |
| 14 raw feature ideas from scoping doc | Pre-project | Consolidated into concept decisions; the ideas themselves are no longer needed |
| Scenario walkthroughs (happy path, edge cases) | Stage 3 | Served their purpose (validated the concept); not needed for stages 6+ |
| Temporal boundary exploration (options A/B/C) | Stage 3 | Decision made (state-based); alternatives no longer relevant |
| One-table-vs-two-table trade-off analysis | Stage 3 | Decision made (one table); trade-off no longer relevant |
| Best-practice constraint details (M3 component lists, Data Tables specs) | Stage 3 | Advisory detail belongs at stages 8/13, not in the distilled concept |
| First-principles reasoning for each decision | Stage 4 | The decisions are kept; the reasoning served its purpose and is in the stage 4 output for reference |

---

## BFT checkpoint (Stage 5 — distillation)

- **Bones:** The bones of this stage are the accumulated material from stages 1–4. The big bones that survived distillation: the essential working principle, the 12 concept-level decisions, the 8 platform constraints, the data model, the screen model. The key-type bone remains the essential working principle.
- **Muscle:** Logic muscle (the three-question fat test applied to every piece of material). No information muscle (no new data gathered — this is removal, not addition). No emotional muscle (preferences don't determine what's fat).
- **Nerves:** Analyzing network (classification: necessary? relevant? important?). Each piece of stage 1–4 material was classified and either kept or cut. This is the purest use of the Analyzing network — division into "keep" vs. "cut."
- **Fat:** This stage IS fat removal. 7 categories of material cut (section 9). What remains is minimal: truth (the principle, the decisions), constraints (platform, data), and relevance (what later stages need). The distilled document is ~60% shorter than the combined stages 1–4 outputs.
- **Skin:** The distilled document is structured as 9 numbered sections — a reference document, not a narrative. Necklace structure (each section stands alone). No up-front conclusion needed — the essential working principle IS the up-front conclusion (section 1).
- **Health:** Good in itself? Yes — every section is necessary (removing it would lose a concept-level truth or constraint), relevant (serves the essential working principle or feeds a later stage), and important (constrains or enables stages 6–17). Good for this project? Yes — the scope is now minimal and precise. The concept is ready to be converted into operational form (stage 6: Project Framing).

---

## Gate: stage-5-distilled

### Full BFT health scan

- **Bones (health):** The concept has a clear skeletal structure — one essential principle, 12 concept decisions, 8 platform constraints, 1 data model, 2 screens. No missing bones: the concept is complete enough to frame a project (stage 6). No extra bones: nothing in the distilled document is non-essential.
- **Muscle (health):** The concept's force comes from the logic of the essential working principle. Every decision traces to it. No decision relies on emotional preference, habit, or channel convenience. The concept is sound.
- **Nerves (health):** The connections are clear: principle → decisions → data model → screens → deferred questions. No broken links. The deferred questions are correctly assigned to stages 8 and 13. The flow from concept to implementation is traceable.
- **Fat (health):** The distillation removed 7 categories of material. What remains is truth, constraints, and relevance. The document is slim and trim. No residual fat detected.
- **Skin (health):** The document is presentable as a reference. A new reader can understand the concept from the distilled document alone, without reading stages 1–4. Communication triad: why read it (to understand the concept), where is the reader (stage 6 will convert this to operational form), what is wanted (a project frame).
- **Health (overall):** **GOOD.** The concept is good in itself (internally consistent, testable, sound) and good for this project (tight scope, fast timeline, testable as a PDLF test). The concept is ready to exit Phase A (Discover) and enter Phase B (Define).

### Gate verdict

**GATE PASSED: stage-5-distilled.** The concept is distilled to truth, constraints, and relevance. Phase A (Discover) is complete. The project is ready to enter Phase B (Define) at stage 6 (Project Framing).

---

*Stage 5 output. Phase A (Discover) complete. Next: Stage 6 (Project Framing) — convert concept into operational form: goals, user flows, workflows, scope, outcomes. Output: Project Concept Document (PCD).*
