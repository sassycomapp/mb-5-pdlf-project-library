# Constraints and Notes — Daily Intentions Tracker

**Date:** 2026-06-30
**Author:** dev-p
**Project slug:** mb5pdlf
**Purpose:** Known constraints, open questions, and context that should inform pdlf stages 6–12 (Define phase). These are not decisions — they are inputs to decisions.

---

## Hard constraints

1. **Platform: Anvil.works.** The mb5pdlf Anvil app already exists. The code repo at `C:\_project-mb5pdlf\mb5pdlf\` is Anvil-connected and git-tracked. anvil.yaml is Anvil-managed — never write to it.
2. **Single user for v1.** No authentication, no multi-tenancy. But the data model should not break if a `user_id` column is added later.
3. **One table for v1.** The `intentions` table as described in the scoping doc. No lookup tables, no junction tables.
4. **Mobile-first responsive web.** No native app, no PWA for v1. Just responsive HTML/CSS via Anvil.
5. **No external APIs.** No integrations, no webhooks, no third-party services. Self-contained.
6. **Timeline: fast.** This is a test project. If it takes more than a few focused sessions, it's too big. Cut scope before extending timeline.

## Soft constraints

1. **Material Design 3.** Use Anvil's MD3 theme. Minimal custom CSS — just spacing and typography. The CSS Overlay approach (per PDLF stage 7 resource list).
2. **Lock-after-midnight.** This is a discipline feature I want, but if it adds significant complexity, it can move to a post-v1 enhancement. The decision belongs at stage 8 (Architecture) or stage 11 (Design Audit).
3. **Three fixed intentions.** My instinct says three. The decision is at stage 4 (Concept Definition). If the concept distillation says "1–5 adjustable," I'll listen to that.

## Open questions (to be resolved during pdlf, not now)

- Should the reflection field be required or optional? (stage 4)
- Should past days be editable within the same day only, or until midnight? (stage 8)
- Should the "morning vs evening" detection be server-side or client-side? (stage 8)
- What happens if the user opens the app for the first time at 3pm? Morning or evening view? (stage 6)
- Should there be a way to skip a day intentionally (e.g., vacation)? (stage 4)
- Is the one-table schema actually right, or should intentions be a separate table linked to a days table? (stage 10)

These questions are written here so the agent has them. They are NOT to be answered in this document. They get answered during the appropriate pdlf stages.

## Context for the pdlf test

This project exists to test pdlf, not to ship a product. That means:

- **Speed matters.** I want to see the full 17-stage pipeline run end-to-end in a few sessions.
- **Honesty matters.** If a stage feels like waste, I want to know. If BFT checkpoints feel like overhead, I want to know. The test is only useful if it's honest.
- **Completeness matters more than perfection.** A working v1 with rough edges is better than a perfect half-finished project. I want to reach stage 17 and 17b so I can see whether the LEARN junction actually produces something useful for the next project.
- **The Anvil code repo is real.** Even though this is a test, the code goes to a real Anvil app via GitHub. It should be deployable.

## What I expect from the agent running pdlf

- The agent should detect that this is the mb5pdlf project (slug from the path).
- The agent should read these three pre-project documents at stage 1.
- The agent should not skip BFT checkpoints even if the stage is simple — the point is to test whether BFT adds value, not to skip it.
- The agent should be honest in the LEARN junction about what worked and what didn't.

---

*This is a constraints and notes document. Hard constraints are non-negotiable. Soft constraints are preferences. Open questions are inputs to pdlf stage decisions, not decisions themselves.*