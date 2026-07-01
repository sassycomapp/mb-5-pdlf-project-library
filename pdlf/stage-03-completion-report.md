# Stage 3 Completion Report — Concept Expansion

**Project:** mb5pdlf
**Stage:** 3 — Concept Expansion
**PDLF Phase:** A (Discover)
**Date:** 2026-06-30
**Duration:** 1 session
**Status:** Complete

## 1. Purpose
Explore the concept's boundaries using imagination, intuition, constraints, and known best practices. Output: an expanded concept model that maps what is inside, outside, and at the boundary of the concept. Per PDLF, this stage uses AI exploration, domain expertise, best practices, systems thinking, and scenario design.

## 2. Inputs
- `pdlf/stage-02-concept-statement.md` — the one-paragraph concept + 5 pillars
- `adr/001-cross-project-anvil-knowledge-reuse.md` — cross-project Anvil knowledge (advisory)
- `pre-project/03-constraints-and-notes.md` — 6 open questions
- GBrain cross-project queries (Junction 0) — mb-3-cs Anvil specs, ADR-034, UI standards

## 3. Work performed

### 3.1 Temporal boundary exploration
Explored the time-dependent aspects of the two-pass daily cycle:
- **Morning/evening detection:** identified three options (fixed thresholds, adaptive/state-based, user toggle). Concluded that state-based detection (morning = no intentions set yet, evening = intentions exist) is the most intuitive. **Resolved open question #4** (first-time-at-3pm → state-based) and **partially resolved #3** (detection method → state-based).
- **Lock-after-midnight:** explored timezone implications. Concluded client-side date comparison is sufficient for v1 (single user, no auth). **Partially resolved open question #2** (edit window → locks when client date changes).
- **Past-midnight, multiple opens, early review:** documented edge cases. All handled naturally by the state-based detection model.

### 3.2 Data boundary exploration
- **One table vs. two:** explored the trade-off. Concept-level insight: if the concept says "exactly three intentions," single table is correct. If "1–5 adjustable," two tables is better. The concept currently says three — so single table is concept-aligned. **Moved the one-table/two-table decision from stage 10 to stage 4** — it's a concept decision, not a data design decision.
- **History depth:** trivial for v1 (365 rows/year, no pagination needed).
- **Deletion:** no UI deletion for v1 (honesty pillar). Direct DB access for emergencies.
- **Future user-proofing:** add `user_id` column (nullable) and `users` table (minimal). Schema-only, no auth implementation.

### 3.3 Interaction boundary exploration
- **Morning "notecard feel":** three `m3.TextArea` components, full-width, no labels, placeholder text. Minimal chrome.
- **Done toggle:** `m3.Switch` (leaning) or `m3.Checkbox`. Deferred to stage 13.
- **History list:** `RepeatingPanel` + `m3.Card` per day (leaning). Deferred to stage 13.
- **Root URL:** startup module handles redirect — no routing module needed for v1.

### 3.4 Scenario exploration
Walked through six scenarios:
1. Happy path (normal day)
2. Skip morning (user sets intentions late — morning mode is state-based, not time-based)
3. Miss a day entirely (gap in history — the gap IS the record)
4. Set intentions but don't review (lock preserves default not-done state)
5. Review early (allowed — app enforces "before midnight," not "in the evening")
6. First-time use (identical to normal morning — no onboarding needed)

### 3.5 Best-practice constraint exploration (cross-project advisory, per ADR-001)
Researched mb-3-cs Anvil proprietary knowledge for the first time:
- **Anvil Data Tables:** confirmed text, bool, date columns available; query patterns identified; no migration tool (schema must be right first time at stage 10).
- **Material Design 3:** confirmed `m3.TextArea`, `m3.Switch`, `m3.Button`, `m3.Card`, `ColumnPanel`, `RepeatingPanel` all native. No partially-supported components needed. Simplest possible M3 app.
- **Pure logic modules:** mb-3-cs pattern (no Anvil imports) applicable for morning/evening detection and lock logic. Advisory — confirm at stage 8.
- **Anvil Extras exclusion:** mb-3-cs rule applies. No extras for mb5pdlf.

### 3.6 Boundary summary
Produced a boundary table mapping every unresolved question to the stage that will resolve it, with current leanings. 9 boundary questions identified, distributed across stages 4, 8, 10, 13.

## 4. Outputs (artifacts produced)

| Artifact | Path | Description |
|---|---|---|
| Expanded concept model | `pdlf/stage-03-expanded-concept-model.md` | 6-section expansion: temporal, data, interaction, scenarios, best-practice, boundary summary |
| Devlog entry 5 | `pdlf/devlog.md` | Stage 3 entry |
| State file | `~/.gstack/projects/mb5pdlf/pdlf-state.md` | Updated: stage 3, substep "expansion-complete" |

## 5. Decisions made

| Decision | Rationale | Deferred to ADR? |
|---|---|---|
| Morning/evening detection is state-based, not clock-based | State-based eliminates the "3pm" edge case and is more intuitive. "Morning" = no intentions set, "evening" = intentions exist. | No — concept decision |
| Lock uses client-side date comparison | Single user, no auth, no timezone complexity. Server stores dates (not datetimes). | No — concept decision, implementation at stage 8 |
| One-table-vs-two-table decision moved to stage 4 | It's a concept decision (depends on "three fixed" vs "adjustable"), not a data design decision | No |
| No onboarding screen | First-time use is identical to a normal morning. Pillar 3 (minimal surface) confirmed. | No |
| No UI deletion for v1 | Honesty pillar — can't rewrite history. Direct DB access for emergencies. | No |
| Cross-project Anvil patterns are advisory, applied for the first time | ADR-001 in action: mb-3-cs specs informed M3 component choices and Data Tables constraints. All advisory. | No — already in ADR-001 |

## 6. Open questions resolved this stage

| Question | Resolution |
|---|---|
| #4: What happens if user opens app for first time at 3pm? | State-based detection: morning mode (no intentions set). Resolved. |
| #3 (partial): Morning/evening detection server-side or client-side? | State-based, not clock-based. Server checks if record exists for today. Partially resolved. |
| #2 (partial): Past days editable within same day or until midnight? | Locks when client date changes. Partially resolved. |

## 7. Open questions still deferred

| Question | Deferred to stage | Current leaning |
|---|---|---|
| Are morning intentions editable before evening review? | Stage 4 | Leaning: yes, editable until evening review starts |
| Three fixed vs. 1–5 adjustable | Stage 4 | Leaning: three fixed |
| Reflection: required or optional? | Stage 4 | Leaning: optional |
| Skip-a-day intentionally | Stage 4 | Leaning: no |
| One table or two? | Stage 4 (concept) → Stage 10 (implementation) | Leaning: one table (if three fixed) |
| Switch or checkbox for done toggle? | Stage 13 | Leaning: `m3.Switch` |
| DataGrid or RepeatingPanel for history? | Stage 13 | Leaning: `RepeatingPanel` + `m3.Card` |

## 8. BFT checkpoint summary
- Bones: five pillars from stage 2, expanded at their boundaries. Key-type bone confirmed: state-based two-pass cycle.
- Muscle: information (cross-project Anvil specs) + logic (edge case analysis). ADR-001 applied for the first time.
- Nerves: Exploring network (bottom-up expansion tree from pillars into edge cases and scenarios).
- Fat: no fat cut yet — stage 5's job. Scenarios could be seen as fat, but for a test project they're the point.
- Skin: 6-section structure with boundary summary table. Tree structure (concept → pillars → boundaries → scenarios).
- Health: good — two open questions resolved, scope didn't expand, honesty pillar held under edge-case pressure.

## 9. Gate status
No gate — next gate at stage 5 (stage-5-distilled).

## 10. Next stage
Stage 4 (Concept Definition) will identify the essential working principle — what the concept actually is — and resolve the four boundary questions assigned to it: editable morning intentions, three fixed vs. adjustable, reflection required/optional, skip-a-day. The one-table-vs-two-table decision will also be made here (concept-level) before implementation at stage 10.

## 11. Maintenance performed
No maintenance run — stage 3 produces planning artifacts only. First maintenance at end of stage 5 (gate: stage-5-distilled).
