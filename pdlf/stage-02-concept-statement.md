# Stage 2 Output — Concept Statement

**Project:** mb5pdlf (Daily Intentions Tracker)
**Stage:** 2 — Concept Synthesis
**Date:** 2026-06-30
**PDLF phase:** A (Discover)

---

## Concept statement

> A mobile-first web application, built on Anvil.works with Material Design 3, where a single user sets three free-text intentions each morning and marks them done or not-done each evening. Past days are viewable in a scrollable history but are locked after midnight — no backfilling, no editing, no streaks. The app is a discipline aid, not a productivity system: under 60 seconds to use in the morning, under 60 seconds in the evening, no reminders, no gamification.

## Synthesis (how the 23 core ideas consolidated)

### From 23 ideas to 5 concept pillars

The 23 core ideas from the idea pool consolidated into five concept pillars. These are not features — they are the structural decisions that define what the app *is*.

**Pillar 1: The two-pass daily cycle**
The app has exactly two interaction points per day: morning (set intentions) and evening (review). There is no midday mode, no "quick check," no dashboard. This is the key-type bone from stage 1 — the whole app hinges on it. Ideas consolidated: #1 (three fixed intentions), #2 (two-pass structure), #10 (time-of-day detection).

**Pillar 2: Honesty over optimization**
The app is deliberately anti-productivity-system. No streaks, no gamification, no analytics, no reminders, no scoring. Past days are locked after midnight — you cannot go back and fix them. The app records what actually happened, not what looks good. Ideas consolidated: #6 (lock after midnight), #7 (no backfilling), #8 (no streaks), #9 (no gamification).

**Pillar 3: Minimal interaction surface**
Three screens maximum: Today (morning/evening), History, and a root redirect. No settings screen, no profile, no onboarding. The morning entry should feel like writing on a notecard — three text fields and a save button. Ideas consolidated: #3 (date-keyed records), #4 (free-text intentions), #5 (optional reflection), #11 (notecard feel), #12 (history as scroll list), #13 (strikethrough for done), #15 (root redirects to Today), #16 (locked day read-only).

**Pillar 4: Anvil-native, M3-native, no external dependencies**
Built entirely on Anvil.works: Data Tables for storage, server-side Python for business logic, Material Design 3 for UI. No external APIs, no third-party services, no authentication for v1. The data model is future-proofed for users but does not implement auth. Ideas consolidated: #17 (single table), #18 (future-proof for users), #20 (server-side lock logic), #21 (Anvil Data Tables), #22 (Anvil server Python), #23 (MD3 theme), #24 (CSS Overlay), #25 (no external APIs), #26 (no auth for v1).

**Pillar 5: Cross-project Anvil knowledge (advisory)**
mb-3-cs Anvil proprietary knowledge (per ADR-001) informs the implementation at stages 8, 10, 13, 14 — but is advisory, not canonical. Three advisory patterns identified: pure logic modules, M3 native components only, Anvil Extras exclusion. To be confirmed at stage 8. Ideas consolidated: #35, #36, #37.

### Ideas consolidated into pillars

| Idea # | Pillar | Note |
|---|---|---|
| 1, 2, 10 | Pillar 1 | Two-pass cycle is the core |
| 6, 7, 8, 9 | Pillar 2 | Honesty features |
| 3, 4, 5, 11, 12, 13, 15, 16 | Pillar 3 | Minimal surface |
| 14 | Pillar 3 | Mobile-first is a constraint, not a pillar of its own |
| 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 | Pillar 4 | Platform decisions |
| 35, 36, 37 | Pillar 5 | Advisory — confirm at stage 8 |

### Ideas from the pool NOT carried into the concept statement

| Idea # | Description | Reason |
|---|---|---|
| 19 | Separate intentions table (days + intentions one-to-many) | Deferred to stage 10 as an open question — not a concept-level decision |
| 27–33 | Rejected ideas (streaks, categories, etc.) | Already rejected at stage 1 |

## BFT checkpoint (Stage 2)

- **Bones:** The bones of this stage are the 23 core ideas from the idea pool. The big bones are the five pillars. The key-type bone is Pillar 1 (the two-pass daily cycle) — it defines what the app *is*. Everything else is structure around it.
- **Muscle:** Logic muscle dominated — this stage is about consolidating and selecting, which requires judgement about what belongs together. Information muscle (the idea pool) was the input. No emotional or habit muscle — this is synthesis, not opinion.
- **Nerves:** Analyzing network (top-down division of the 23 ideas into 5 groups). The classification basis is "structural role in the concept" — each pillar is a load-bearing concept decision. Some overlap between pillars (idea #14 is in Pillar 3 but is also a constraint) — acceptable at concept level.
- **Fat:** Idea #19 (separate table) was deferred, not cut — it's a stage 10 question. No fat in the concept statement itself — it's one paragraph. The pillars are structural, not elaboration.
- **Skin:** Up-front concept statement (one paragraph), then synthesis (pillars with consolidated idea mapping). Tree structure: concept → pillars → ideas. Clear separation of carried-forward vs. deferred vs. rejected.
- **Health:** Good in itself? Yes — the concept statement is clear, specific, and testable. Good for this project? Yes — the scope is right for a fast test (one table, two screens, no auth). The concept doesn't overreach. The honesty features (Pillar 2) are the differentiator — without them, this is just a to-do list.

---

*Stage 2 output. Next: Stage 3 (Concept Expansion) — explore the concept's boundaries using imagination, intuition, constraints, and known best practices.*
