# Pre-Project Brief — Daily Intentions Tracker

**Date:** 2026-06-30
**Author:** dev-p
**Project slug:** mb5pdlf
**Purpose:** First-thoughts document to feed into pdlf stage 1 (Ideation). This is raw thinking, not a spec.

---

## What I want to build

A small web app where I set 1–3 intentions at the start of each day and mark them done or not-done at the end of the day. That's it. No analytics dashboards, no streaks, no gamification, no social features. Just: what do I intend to do today, and did I do it.

## Why

I've tried habit trackers. They all do too much. I spend more time managing the tracker than doing the things. I want the opposite: the app should take less than 60 seconds in the morning and less than 60 seconds in the evening. If it takes longer, I won't use it.

The core value is the act of stating an intention before the day starts and honestly reviewing it at the end. The app is just a structure that makes that act repeatable. It is not a productivity system. It is a discipline aid.

## What I think the screens are

I see roughly three things:
1. **Morning view** — "What are your intentions for today?" Three text fields. Save button. Should feel like writing on a notecard, not filling a form.
2. **Evening view** — "How did you do?" Same three intentions, each with a done/not-done toggle. Optional one-line reflection field. Save button.
3. **History view** — a list of past days. Just the dates, the intentions, and whether they were done. No charts. Scrollable. That's all.

I don't think I need a settings screen for v1. Maybe later.

## What I know I don't know

- I don't know whether "intentions" should be free text or picked from a list. My instinct is free text — intentions are personal and change daily. But I might be wrong.
- I don't know whether I want a reminder (push notification or email). I think no for v1 — if I need a reminder, the app has already failed. But I'm open.
- I don't know whether one user is enough or whether this should support multiple users from day one. My instinct: single user for v1, but build the data model so it doesn't break if I add users later.
- I don't know what the reflection field should be. Optional? Required? Character limit? I'll decide during design.

## What I want from this test

This project is primarily a test of the pdlf workflow itself. I want to see:
- Whether the 17-stage pipeline feels natural or forced for a small project
- Whether the BFT checkpoints add value or just add overhead
- Whether the ISA is a useful artifact or just paperwork
- Whether the single-step "continue" cadence keeps me engaged or slows me down
- Whether the LEARN junction at the end actually makes the next project easier

If pdlf adds 30% overhead but the resulting code is cleaner and I learned something for the next project, that's a win. If it adds 30% overhead and I learned nothing, the test failed.

## Rough timeline

I want this to be fast. Not a week, not a month. If I can't get to a deployable v1 in a few focused sessions, the project is too big for a test. I'd rather cut scope than extend timeline.

---

*This is a first-thoughts document. Everything here is provisional and will be refined or discarded during pdlf stages 1–5 (Ideation → Distillation).*