# Scoping Ideas — Daily Intentions Tracker

**Date:** 2026-06-30
**Author:** dev-p
**Project slug:** mb5pdlf
**Purpose:** Raw ideation and scoping notes. Deliberately messy — this is brainstorming, not a spec.

---

## Feature ideas (no filter yet)

These are things that crossed my mind. Some are good. Some are fat. The point of writing them all down is to let pdlf stage 5 (Distillation) cut them.

1. **Three intentions per day** — fixed number, not adjustable. Forces prioritisation.
2. **Morning entry + evening review** — two-pass structure. Set in the morning, mark in the evening.
3. **Optional reflection field** — one line, optional, at evening review. "What shifted today?"
4. **History list** — scrollable list of past days. Date, intentions, done/not-done. No charts.
5. **Date-based** — each day is its own record. Can't backfill past days (honesty). Can view past days but not edit them after midnight.
6. **Lock after midnight** — once the day rolls over, the record is locked. You can't go back and mark yesterday's intentions as done. This is a discipline feature, not a technical one.
7. **Single user for v1** — no auth, no multi-tenant. Just me. But structure the data so adding users later doesn't require a rewrite.
8. **No reminders** — if I need a reminder, the habit isn't forming. The app should be something I *want* to open, not something I'm nagged to open.
9. **Mobile-friendly** — I'll check this on my phone in the morning and evening. Doesn't need to be a PWA or native app. Just responsive web.
10. **Export to markdown** — a button that downloads all past days as a single markdown file. Nice-to-have. Probably fat for v1.
11. **Streaks** — no. Deliberately no. Streaks make you game the system. I want honesty, not a score.
12. **Categories/tags** — no. Intentions are free text. Categorising them adds friction.
13. **Sharing** — no. Intentions are private.
14. **Weekly review** — maybe later. Not v1.

## What I think the data model is

One table: `intentions`
- `date` (date, unique — one record per day)
- `intention_1` (text)
- `intention_2` (text)
- `intention_3` (text)
- `done_1` (bool, default false)
- `done_2` (bool, default false)
- `done_3` (bool, default false)
- `reflection` (text, optional)
- `locked` (bool, default false — set to true after midnight)
- `created_at` (datetime)
- `updated_at` (datetime)

That's it. One table, eleven columns. If I later add users, I add a `user_id` column and a `users` table. The schema doesn't break.

I'm not sure about the three-fixed-intentions structure. Maybe it should be 1–5, not exactly 3. Three feels right — it forces prioritisation without being overwhelming. But I might be wrong. This is a stage-4 (Concept Definition) decision.

## What I think the UI is

Two main screens, maybe three:

**Screen 1 — Today (morning or evening)**
The app detects what time of day it is and shows either:
- Morning: three empty text fields + "Set intentions" button
- Evening: three text fields (pre-filled from morning) + three done/not-done toggles + reflection field + "Save review" button

If the day is already locked (past midnight), show the day's record read-only with a message: "This day is locked."

**Screen 2 — History**
A scrollable list of past days. Each row: date, three intentions (strikethrough if done), reflection (if any). Tap to expand. No filter, no search. Just scroll.

**Screen 3 — maybe a landing/redirect**
If the user navigates to the root URL, redirect to "Today." I don't need a home screen.

## What I think the tech is

- **Anvil.works** — already set up (the mb5pdlf Anvil app exists)
- **Anvil Data Tables** — one table as above
- **Anvil server-side Python** — the lock-after-midnight logic, the "is it morning or evening" logic
- **Material Design 3** — Anvil's MD3 theme, minimal customisation
- **CSS Overlay** — minimal, just spacing and typography adjustments

No external APIs. No authentication for v1. No database migrations. One table, two screens.

## What success looks like

- I can open the app on my phone, set three intentions in under 60 seconds, and close it.
- I can open it in the evening, mark them done/not-done in under 60 seconds, and close it.
- The history view shows me past days without making me feel bad about the ones I missed.
- The code is clean enough that I could hand it to someone and they'd understand it in 10 minutes.

## What failure looks like

- The app takes more than 90 seconds to use in the morning or evening.
- I add features during the build that weren't in the distillation.
- The data model needs to be rewritten when I add a second user.
- The pdlf process felt like paperwork instead of thinking.

---

*This is a scoping ideas document. Everything here is provisional and will be filtered during pdlf stages 1–5. The presence of an idea here does not mean it will be in v1.*