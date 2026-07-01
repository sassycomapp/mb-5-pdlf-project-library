# Stage 4 Output — Core Concept Definition

**Project:** mb5pdlf (Daily Intentions Tracker)
**Stage:** 4 — Concept Definition
**Date:** 2026-06-30
**PDLF phase:** A (Discover)

---

## Method

First-principles thinking. The goal of this stage is to identify the essential working principle — what the concept actually *is* — by stripping away everything that is not essential and asking: what is the irreducible core that makes this thing what it is?

This is not feature selection (that was stage 2) and not boundary exploration (that was stage 3). This is abstraction: finding the one sentence that, if changed, would make the app a different app.

---

## 1. The essential working principle

> **The app converts the act of daily intention-setting from a fleeting thought into a committed, irreversible record.**

That is the irreducible core. Everything else — the two-pass cycle, the lock, the history, the honesty features — exists to *serve* this principle. If you remove the irreversibility, the app becomes a to-do list. If you remove the intention-setting, it becomes a journal. If you remove the daily cycle, it becomes a notes app. The principle is: **state it, commit it, live with it.**

### What this principle implies

1. **Commitment is the value.** The act of writing down an intention is valuable only because you cannot take it back. If you could edit it, the morning statement would be meaningless — you'd be tracking a changing list, not stating an intention.

2. **The record is the product.** The app's output is not a dashboard, not a score, not a streak. It is a record: "on this day, you said you would do X, and you did/didn't do X." The history view exists to make this record visible, not to analyse it.

3. **Honesty is structural, not motivational.** The lock-after-midnight, the no-streaks rule, the no-backfilling rule — these are not motivational features. They are structural constraints that make dishonesty impossible. You cannot rewrite what you said. You cannot inflate what you did. The app is honest by construction.

4. **Friction is the feature, not the bug.** The inability to edit, the gap when you miss a day, the not-done defaults — these are not UX problems to solve. They are the mechanism by which the app works. A frictionless intentions app is a to-do list, and to-do lists don't change behaviour.

---

## 2. Boundary question resolutions

Four boundary questions were assigned to this stage at stage 3. Each is resolved here from first principles, not from preference.

### 2.1 Are morning intentions editable before evening review?

**Resolution: NO. Intentions are not editable after the first save.**

**First-principles reasoning:** The essential working principle says the app converts intention-setting into a *committed, irreversible* record. If intentions are editable after save, the record is not committed — it's a draft. The morning save is the moment of commitment. After that, the intention text is read-only for the rest of the day.

**What about typos?** If you typo an intention at 7am, you live with it. The typo is part of the record. If it's truly unintelligible, you can note the correction in the evening reflection ("intention 2 was meant to say X"). The reflection field is the only place where post-commit commentary is allowed.

**Interaction design consequence:** Once the user taps "Set intentions" (the save button), the three text areas become read-only. The app transitions from morning mode to evening mode. There is no "edit morning intentions" mode.

### 2.2 Three fixed vs. 1–5 adjustable?

**Resolution: THREE FIXED. Not adjustable.**

**First-principles reasoning:** The essential working principle is about *commitment*. If the user can choose how many intentions to set, the number itself becomes a daily decision — which is friction at the wrong level. The friction should be in *choosing* the three, not in *deciding how many*. Three is the Goldilocks number: enough to cover a day's real priorities, few enough to force genuine choice.

If you allow one, the user will set one (easy, no commitment). If you allow five, the user will set five (diluted, no prioritisation). Three forces the user to decide what actually matters today.

**Data model consequence:** three fixed intentions = a single table with three text columns and three bool columns. No separate intentions table needed. This resolves the one-table-vs-two-table question (section 2.5).

**Concept consequence:** "Three" is now a concept-level decision, not a configuration. Changing it would be a concept change, not a feature toggle.

### 2.3 Reflection: required or optional?

**Resolution: OPTIONAL.**

**First-principles reasoning:** The essential working principle is about the *intention record*, not the reflection. The reflection is a secondary artifact — a place for post-commit commentary. If the reflection were required, it would add friction to the evening review, threatening the "under 60 seconds" goal. More importantly, a forced reflection is not honest — it's homework.

The reflection exists for the user who *wants* to note something. If there's nothing to say, the field stays empty. The record is complete without it.

**Interaction design consequence:** the reflection field is present in evening mode but has no required validator. The save button is always enabled. An empty reflection is a valid state.

### 2.4 Skip-a-day intentionally?

**Resolution: NO SKIP FEATURE.**

**First-principles reasoning:** The essential working principle says the record is the product. If you're on vacation and don't open the app, the day has no record — and that *absence* is the record. The gap in history is honest: you didn't set intentions that day.

A "skip" feature would create a record that says "I chose not to participate" — which is a *meta-commentary* on the app, not an intention. It adds a third state (intended, didn't-intend, skipped) to what should be a binary system (intended or didn't). It also adds UI complexity (a skip button, a skipped-day display in history) for no structural value.

If the user wants to note "I'm on vacation," they can set an intention that says "Rest day — no intentions" and mark it done in the evening. The app doesn't need to know it's a vacation. The concept doesn't need a skip state.

### 2.5 One table or two? (moved from stage 10)

**Resolution: ONE TABLE.**

**First-principles reasoning:** The concept says three fixed intentions (section 2.2). Three fixed intentions is a fixed schema: three text columns, three bool columns, plus date, reflection, locked, timestamps. There is no need for a separate `intentions` table with a one-to-many relationship to a `days` table — that would be normalisation for a flexibility the concept explicitly rejects.

If the concept later changed to adjustable intentions (1–5), a two-table design would be better. But that is a concept change, not a data design choice. The data design (stage 10) implements the concept, not the other way around.

**Data model consequence:** one table, `intentions`, with columns: `date`, `intention_1`, `intention_2`, `intention_3`, `done_1`, `done_2`, `done_3`, `reflection`, `locked`, `created_at`, `updated_at`. The `user_id` column is added (nullable, for future-proofing per the constraints doc) but no `users` table is created at v1 — that would imply auth, which is out of scope.

---

## 3. What the concept actually IS (the definition)

Having resolved the boundary questions, the concept can now be defined precisely:

> **The Daily Intentions Tracker is a single-user web application (Anvil + MD3) that enforces a two-pass daily discipline cycle: the user commits to exactly three free-text intentions each morning (irrevocably, upon save), and reviews them as done or not-done each evening (before client-side midnight, after which the record locks). Past days are visible as a scrollable history of immutable records with gaps for missed days. There are no streaks, no analytics, no reminders, no editing, no skipping, and no settings. The reflection field is optional. The data model is a single table, future-proofed for multi-user but not implementing auth.**

This is the concept definition. Everything in this paragraph is a concept-level decision. Changing any element (three → adjustable, irrevocable → editable, no-skip → skip) would make it a different app.

---

## 4. What is NOT a concept-level decision

The following are implementation decisions, deferred to later stages:

| Decision | Stage | Note |
|---|---|---|
| M3.Switch vs M3.Checkbox for done toggle | 13 | Both are M3 native; either works |
| RepeatingPanel vs DataGrid for history | 13 | UX choice, not concept |
| Server-side vs client-side lock enforcement | 8 | Concept says client-side date comparison (stage 3); architecture decides implementation |
| Pure logic modules vs inline logic | 8 | mb-3-cs pattern (advisory); architecture decides |
| CSS overlay specifics | 13 | Design decision |
| Anvil routing vs startup redirect | 8 | Architecture decision |

---

## BFT checkpoint (Stage 4)

- **Bones:** The bones of this stage are the five boundary questions. The big bones are the four resolutions (no-edit, three-fixed, optional-reflection, no-skip) and the one-table decision. The key-type bone is the essential working principle itself: "the app converts the act of daily intention-setting from a fleeting thought into a committed, irreversible record." Everything else hangs on this.
- **Muscle:** Logic muscle dominated — first-principles reasoning for each boundary question. Each resolution was derived from the essential working principle, not from preference. No emotional muscle (preferences were explicitly rejected as a basis). No habit muscle (the concept deliberately rejects convention — most tracker apps allow editing, streaks, adjustable counts). No channel muscle (no existing channels leveraged — this is greenfield). Information muscle (cross-project Anvil specs from stage 3) was input but did not drive decisions.
- **Nerves:** Analyzing network (top-down decomposition of the concept into its essential principle and derivative decisions). The classification basis is "is this essential to the concept or is it implementation?" Everything essential was resolved here; everything implementation was deferred.
- **Fat:** The reflection on typos ("you live with it, note it in reflection") could be seen as fat — it's a consequence, not a decision. But it illustrates the concept's stance, so it's kept. The "what about vacation" discussion in 2.4 is similar — it's a scenario, not a decision, but it justifies the decision. No fat cut; no fat added that doesn't serve the definition.
- **Skin:** The definition (section 3) is presented as a single dense paragraph — the concept in one block. Up-front: the essential working principle (one sentence). Then: boundary resolutions with first-principles reasoning. Then: the full definition. Tree structure: principle → resolutions → definition → deferred items.
- **Health:** Good in itself? Yes — the definition is specific, testable, and internally consistent. Every resolution traces back to the essential working principle. Good for this project? Yes — the scope is tight (one table, two screens, no auth, no settings), the timeline is achievable, and the concept is different enough from a to-do list to be worth building. The honesty pillar is now structurally enforced, not just aspirational.

---

*Stage 4 output. Next: Stage 5 (Concept Distillation) — remove fluff, assumptions, duplication, and non-essential details. Keep only truth, constraints, and relevance. The distillation will take the concept definition and strip it to its minimal form.*
