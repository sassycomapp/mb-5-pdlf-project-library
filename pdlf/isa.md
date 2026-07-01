# ISA — Ideal State Artifact

**Project:** mb5pdlf (Daily Intentions Tracker)
**Published:** 2026-06-30 (Stage 12 — Design Lockdown)
**Status:** BASELINE v1 — LOCKED
**ISA version:** 1.0

---

## 1. Problem

People set daily intentions mentally but rarely commit to them in a form that survives the day. Mental intentions are forgotten, revised, and rationalised. Existing habit trackers add friction (streaks, gamification, analytics) that shifts focus from honest intention-setting to score management.

## 2. Vision

A single-user web app where the act of setting three daily intentions is converted from a fleeting thought into a committed, irreversible record. The user sets intentions in the morning, reviews them honestly in the evening, and sees their history as an immutable record with gaps for missed days. Under 60 seconds per session. No streaks, no gamification, no editing, no settings.

## 3. Out of Scope

- Authentication / multi-user (v1)
- Settings screen
- Onboarding / tutorial / welcome screen
- Streaks, gamification, analytics, reminders, notifications
- Export to markdown
- Editing intentions after save
- Skip-a-day feature
- Search / filter / pagination in history
- External API integrations
- Anvil Extras
- Custom (non-M3) components
- Anvil Routing module
- Weekly review

## 4. Principles

- **Commitment requires irreversibility.** Intentions are not editable after first save.
- **Honesty is structural, not motivational.** The lock-after-midnight, no-streaks, and no-backfill rules make dishonesty impossible by construction.
- **Friction is the feature, not the bug.** The inability to edit, the gap for missed days, the not-done defaults — these are the mechanism, not UX problems.
- **The record is the product.** The app's output is an immutable record, not a dashboard or a score.
- **Anvil-first.** Default to Anvil's built-in facilities. Custom implementations require documented justification. (Adopted from mb-3-cs via ADR-001.)
- **M3 native only.** No custom components, no non-M3 components, no Anvil Extras. (Adopted from mb-3-cs via ADR-001.)

## 5. Constraints

- Platform: Anvil.works (runtime v3, python310-minimal)
- UI: Material Design 3 (dependency `4UK6WHQ6UX7AKELK`, v1.2.6) — installed and verified
- Data: Anvil Data Tables (1 table, no migration tool, no external database)
- Single user, no auth for v1 (`user_id` column nullable for future-proofing)
- Mobile-first responsive web
- No external APIs, no webhooks, no third-party services
- anvil.yaml: never written to (AGENTS.md hard rule)
- Timeline: fast — few focused sessions (test project)
- No Anvil Routing dependency (startup redirect)

## 6. Goal

Ship a deployable v1 of the Daily Intentions Tracker on Anvil via GitHub, with a two-pass daily discipline cycle (morning set + evening review), lock-after-midnight, and scrollable history — in a few focused sessions, as a test of the PDLF workflow.

## 7. Criteria (ISCs)

| # | ISC | How to verify | Status |
|---|-----|---------------|--------|
| ISC-1 | Morning form accepts 3 free-text intentions and saves them irrevocably | Manual test: open morning form, type 3 intentions, save → record exists; attempt to edit → rejected | pending |
| ISC-2 | Evening form shows 3 read-only intentions, 3 done toggles, optional reflection, and saves | Manual test: open evening form, intentions read-only, toggle done states, type reflection, save → record updated | pending |
| ISC-3 | Record locks when client-side date changes (past midnight) | Automated test: `should_lock()` returns true for past date; manual test: app after midnight → locked form shown | pending |
| ISC-4 | History view displays all past records in date-descending order with gaps for missed days | Manual test: create records for day 1 and day 3, skip day 2 → history shows day 3, day 1, gap visible | pending |
| ISC-5 | Locked records are read-only with "This day is locked" message | Manual test: open app when today is locked → locked form shown, no buttons, message displayed | pending |
| ISC-6 | App is deployed and accessible via Anvil URL | Deploy to Anvil via GitHub, verify URL loads and responds | pending |

## 8. Test Strategy

| Layer | Test type | Tool | What's tested |
|---|---|---|---|
| `date_logic.py` | Unit tests | Python `unittest` (no Anvil needed) | `get_client_today()`, `is_past_date()`, `should_lock()` |
| `record_ops.py` | Unit tests | Python `unittest` (no Anvil needed) | `determine_state()`, `validate_intentions()`, `validate_review()` |
| `server_calls.py` | Integration | Manual (Anvil runtime required) | All 4 callable functions |
| Forms | Manual QA | GStack `/qa` skill (stage 16) | All 4 forms + startup redirect |
| Full app | UAT | Manual (stage 17) | All 6 ISCs |

## 9. Features

| Feature | Satisfies ISC | Notes |
|---------|---------------|-------|
| Morning form (3 text areas + save, irrevocable) | ISC-1 | `MorningForm`, `set_intentions()` |
| Evening form (3 read-only + 3 toggles + reflection + save) | ISC-2 | `EveningForm`, `save_review()` |
| Lock enforcement (check_and_lock_past_days) | ISC-3, ISC-5 | ADR-003 (hybrid: client date + server enforcement) |
| History view (scrollable, RepeatingPanel + m3.Card) | ISC-4 | `HistoryForm`, `get_history()` |
| Locked day display (read-only + message) | ISC-5 | `LockedForm` |
| Deployment to Anvil via GitHub | ISC-6 | Stage 16–17 |

## 10. Decisions

| Decision | Rationale | ADR | Date |
|----------|-----------|-----|------|
| Cross-project Anvil knowledge reuse (advisory) | mb-3-cs has Anvil platform knowledge applicable to mb5pdlf | ADR-001 | 2026-06-30 |
| Pure logic module architecture | Testable without Anvil; adopted from mb-3-cs pattern | ADR-002 | 2026-06-30 |
| Hybrid lock enforcement | Client-side timezone + server-side authority | ADR-003 | 2026-06-30 |
| Three fixed intentions (not adjustable) | Forces prioritisation; adjustable dilutes commitment | — (concept) | 2026-06-30 |
| Intentions irrevocable after first save | Commitment requires irreversibility | — (concept) | 2026-06-30 |
| One table (not two) | Three fixed = fixed schema; two-table is for rejected flexibility | — (concept) | 2026-06-30 |
| No routing dependency | 2 screens, startup redirect — routing adds complexity without value | — (architecture) | 2026-06-30 |
| No Anvil Extras | M3 native components cover all needs; adopted from mb-3-cs ADR-014 | — (stack) | 2026-06-30 |

## 11. Changelog

| Date | Change | Stage |
|------|--------|-------|
| 2026-06-30 | ISA created — baseline v1 locked | 12 |

## 12. Verification

*Filled at stage 17 (Validation & Release).*

| ISC | Verdict | Evidence |
|-----|---------|----------|
| ISC-1 | pending | |
| ISC-2 | pending | |
| ISC-3 | pending | |
| ISC-4 | pending | |
| ISC-5 | pending | |
| ISC-6 | pending | |

---

## Baseline v1 lock

The following artifacts constitute **Baseline v1** and are frozen as of this ISA publication:

| Artifact | Path | Stage |
|---|---|---|
| Distilled concept document | `pdlf/stage-05-distilled-concept-document.md` | 5 |
| Project Concept Document (PCD) | `pdlf/stage-06-project-concept-document.md` | 6 |
| Technology & Delivery Stack | `pdlf/stage-07-technology-delivery-stack.md` | 7 |
| Architecture Specification | `pdlf/stage-08-architecture-specification.md` | 8 |
| PRD | `pdlf/stage-09-prd.md` | 9 |
| Data Model | `pdlf/stage-10-data-model.md` | 10 |
| Design Sanity Audit | `pdlf/stage-11-design-sanity-audit.md` | 11 |
| ADR-001 | `adr/001-cross-project-anvil-knowledge-reuse.md` | 1 |
| ADR-002 | `adr/002-pure-logic-module-architecture.md` | 8 |
| ADR-003 | `adr/003-lock-enforcement-strategy.md` | 8 |
| This ISA | `pdlf/isa.md` | 12 |

**Change control:** Any change to Baseline v1 artifacts requires a documented reason (per PDLF backward reopen rules: 17→13/8/9/10) and a devlog entry marked [REOPEN].

---

*ISA version 1.0. Baseline v1 locked. Stage 12 — Design Lockdown. 2026-06-30.*
