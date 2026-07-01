# Stage 3 Output — Expanded Concept Model

**Project:** mb5pdlf (Daily Intentions Tracker)
**Stage:** 3 — Concept Expansion
**Date:** 2026-06-30
**PDLF phase:** A (Discover)

---

## Method

Exploring network (bottom-up expansion tree). Started from the concept statement's five pillars and expanded outward into edge cases, scenarios, and best-practice constraints. No filtering — that happens at stage 5 (Distillation). The goal is to map the concept's boundaries.

---

## 1. Temporal boundary exploration

The two-pass daily cycle (Pillar 1) depends on time. Time is messy.

### 1.1 When does "morning" end and "evening" begin?

The concept says the app detects time of day. But what are the boundaries?
- **Option A:** Fixed thresholds (morning = 04:00–12:00, evening = 16:00–23:59, midday = 12:00–16:00 is a gap)
- **Option B:** Adaptive — morning = before any intentions set today, evening = after intentions set and before midnight
- **Option C:** No detection — user picks "morning" or "evening" via a toggle

Option B is the most intuitive: if you haven't set intentions yet, you're in "morning" mode regardless of the clock. If you have, you're in "evening" mode. This eliminates the "what if I open it at 3pm?" open question — the answer is "morning mode if no intentions set, evening mode if intentions exist." **This resolves open question #4 (first-time-at-3pm) and partially resolves #3 (morning/evening detection).**

### 1.2 What defines "midnight" for the lock?

- **Server-side midnight (UTC):** simplest, but wrong for a user in a different timezone
- **Server-side midnight (user's timezone):** correct, but requires knowing the user's timezone
- **Client-side midnight (browser timezone):** can be spoofed, but for a single-user discipline app, spoofing yourself is self-defeating

For v1 (single user, no auth), client-side timezone detection is sufficient. The server stores dates as date values (not datetimes), and the lock check compares the client's "today" against the record's date. **This partially resolves open question #2 (past-day edit window) — the record locks when the client's date changes.**

### 1.3 What if the user is up past midnight?

If the user opens the app at 00:30 on May 2, the app sees "today = May 2" and there's no record for May 2 yet → morning mode. The May 1 record is locked. The user cannot review May 1 at 00:30 on May 2.

This is a discipline feature, not a bug. If you didn't review by midnight, you missed it. The concept statement's honesty pillar (Pillar 2) supports this.

### 1.4 What about timezones and travel?

For v1: ignore. Single user, single timezone. The client's browser timezone is the timezone. If the user travels, the app adapts to the new timezone. No timezone picker, no settings.

### 1.5 What if the user opens the app multiple times in the morning?

First open: morning mode, empty fields. User sets intentions and saves. Second open: intentions already exist for today → evening mode (review). The user can review early if they want. This is fine — honesty means "did you do it," not "did you wait until evening."

### 1.6 What if the user opens the app, sets intentions, then wants to change them before evening?

**Open question:** should morning intentions be editable until the evening review starts?
- If yes: the user can refine intentions during the day (reasonable)
- If no: once set, locked until evening review (stricter discipline)

**Deferred to stage 4 (Concept Definition).** The concept statement doesn't specify this. It's a concept-level decision, not an architecture one.

---

## 2. Data boundary exploration

### 2.1 One table vs. two tables

The idea pool deferred idea #19 (separate days + intentions tables) to stage 10. But concept expansion should explore the trade-off:

**Single table (`intentions`):**
- Pros: simpler, fewer joins, matches the "three fixed intentions" concept
- Cons: if intentions become adjustable (1–5), the schema needs changing; three columns per intention (text + done flag) is denormalised

**Two tables (`days` + `intentions`):**
- Pros: normalised, supports adjustable intention count, each intention is a row
- Cons: more complex, more queries, over-engineered for three fixed intentions

**Concept-level insight:** if the concept says "exactly three intentions" (Pillar 1), the single table is correct. If the concept says "1–5 adjustable intentions," two tables is better. The concept statement currently says "three" — so single table is the concept-aligned choice. But the open question (#6 from constraints) asks whether three is right. **This should be resolved at stage 4, not stage 10.** Stage 10 then implements the concept decision.

### 2.2 How much history?

The concept says "scrollable history." How far back?
- Anvil Data Tables can handle thousands of rows — a year of daily records is 365 rows, trivial
- No pagination needed for v1 — just load all records and scroll
- If the app runs for years, a "load more" pattern might be needed, but that's a post-v1 concern

### 2.3 What if the user deletes data?

**Decision needed:** can the user delete past records?
- The honesty pillar suggests no — you can't rewrite history
- But GDPR/data hygiene suggests the user should be able to export and delete
- For v1: no deletion from the UI. Direct database access for emergency cleanup. Export is deferred (idea #27, fat for v1).

### 2.4 Future user-proofing

The concept says "single user for v1, but data model doesn't break if users added." What does this mean concretely?
- Add a `user_id` column to the `intentions` table (nullable for v1, defaults to a single known value)
- Add a `users` table (minimal: id, email, created_at)
- No auth implementation — just the schema structure
- This is a data design decision (stage 10), but the concept must endorse the approach

---

## 3. Interaction boundary exploration

### 3.1 The "notecard feel" (Pillar 3)

The concept says morning entry should "feel like writing on a notecard." What does this mean in Anvil + MD3?
- Three `m3.TextArea` components (not `m3.TextBox` — textareas feel more like writing)
- Large, full-width, no labels like "Intention 1" — just placeholder text ("What do you intend today?")
- Minimal chrome — no card borders, no headers, just the text areas and a save button
- The save button is `m3.Button` (filled), primary action

**Best-practice constraint (from mb-3-cs `docs/ui-standards.md`, advisory per ADR-001):** use M3 native components only, no custom components for v1. The CSS Overlay approach handles spacing/typography only, not component structure.

### 3.2 The done/not-done toggle

Evening review needs a per-intention done/not-done toggle. In M3:
- `m3.Switch` (toggle) — natural for binary state
- Or `m3.Checkbox` — also natural, slightly different semantics (checked = done)
- Switch feels more intentional ("I did this" / "I didn't") vs. checkbox (task completion)
- **Best-practice constraint:** both are M3 native. Choice is a UX decision (stage 13).

### 3.3 The history list

- `DataGrid` is the Anvil native list component, but it's tabular — feels like a spreadsheet, not a journal
- A `ColumnPanel` (RepeatingPanel) with custom cards per day feels more like a journal
- Each card: date header, three intentions (strikethrough if done), reflection (if any)
- **Best-practice constraint:** M3 `Card` component for each day entry. `RepeatingPanel` for the list. This is the mb-3-cs pattern (advisory).

### 3.4 What about the root URL redirect?

The concept says "root URL redirects to Today." In Anvil:
- Anvil's routing module (Dependency ID: 3PIDO5P3H4VPEMPL, per mb-3-cs `docs/anvil-spec-table.md` — advisory)
- Or a simple `open_form` call in the startup module
- For v1: startup module checks if today's record exists → morning or evening form. No routing needed.

---

## 4. Scenario exploration

### 4.1 Happy path — a normal day

1. **07:00:** User opens app. No record for today. Morning mode. Three empty text areas. User types three intentions. Saves. App confirms. Closes.
2. **21:00:** User opens app. Record exists for today, not locked. Evening mode. Three intentions shown (read-only), each with a switch. User toggles two as done, one not-done. Types a one-line reflection. Saves. App confirms. Closes.
3. **Next day, 07:00:** User opens app. Yesterday's record is locked. No record for today. Morning mode.

### 4.2 Edge case — user skips morning

1. User wakes up late, rushes to work, doesn't open the app in the morning.
2. **18:00:** User opens app. No record for today. App shows morning mode (no intentions set yet).
3. User sets intentions at 18:00. This is late but valid — better late than never.
4. **21:00:** User opens app. Record exists. Evening mode. Reviews.

**Insight:** morning mode is not time-bound — it's state-bound. "Morning" = "no intentions set yet." This confirms the Option B detection from section 1.1.

### 4.3 Edge case — user misses a day entirely

1. May 1: user sets intentions, reviews in evening. Normal day.
2. May 2: user doesn't open the app at all.
3. May 3, 07:00: user opens app. May 2 has no record. May 3 has no record. App shows morning mode for May 3.

**Insight:** May 2 simply doesn't exist in the data. The history view shows May 1, then May 3 — a gap. The gap is the record. This is the honesty pillar — you can't fake a day you missed.

### 4.4 Edge case — user sets intentions but doesn't review

1. **07:00:** User sets three intentions. Saves.
2. User forgets to review in the evening.
3. **23:59:** Still not reviewed.
4. **00:01:** Date changes. Record locks. All three intentions are marked not-done (default false).

**Insight:** the lock preserves the default state (not-done). The user sees in history that they set intentions but didn't review — the switches are all off. This is honest. The reflection field is empty.

### 4.5 Edge case — user reviews early

1. **07:00:** User sets three intentions.
2. **10:00:** User opens app. Record exists. Evening mode. User reviews at 10am.

**Insight:** this is allowed. The app doesn't enforce "review in the evening" — it enforces "review before midnight." If you review at 10am, you're reviewing your morning intentions, which is premature but not forbidden. Honesty is self-enforced.

### 4.6 Edge case — first-time use

1. User opens the app for the first time ever. No records exist. No record for today.
2. App shows morning mode. Three empty text areas. User sets intentions.

**Insight:** first-time use is identical to a normal morning. No onboarding screen needed. The concept's Pillar 3 (minimal surface) is confirmed — no onboarding, no tutorial, no "welcome" screen.

---

## 5. Best-practice constraint exploration (cross-project advisory, per ADR-001)

### 5.1 Anvil Data Tables constraints

From mb-3-cs `docs/anvil-spec-table.md` section 4 (advisory):
- Data Tables support text, bool, date, datetime, int, float, media columns
- Row-level security is available but not needed for v1 (single user)
- Query patterns: `app_tables.intentions.get(date=today)` for the current day, `app_tables.intentions.search()` ordered by date descending for history
- No migration tool — schema changes are manual. This means the stage 10 schema must be right the first time.

### 5.2 Material Design 3 constraints

From mb-3-cs `docs/ui-standards.md` (advisory):
- M3 theme dependency: `4UK6WHQ6UX7AKELK` (same as mb-3-cs)
- Native M3 components: `m3.TextArea`, `m3.Switch`, `m3.Button`, `m3.Card`, `ColumnPanel`, `RepeatingPanel`
- Partially supported (custom composition needed): Chips, Snackbar, Bottom Sheet, Tabs, Date Picker
- For mb5pdlf v1: only native M3 components needed. No partially-supported components. This is the simplest possible M3 app.

### 5.3 Anvil server-side Python constraints

From mb-3-cs `docs/architecture.md` (advisory):
- Pure logic modules (no Anvil imports) for testable business logic
- For mb5pdlf: the morning/evening detection, lock logic, and date handling could be pure logic modules
- Server calls via `@anvil.server.callable` for client-server communication
- For mb5pdlf: two server calls — `get_today_record()` and `save_record(date, intentions, review)`

### 5.4 Anvil Extras exclusion

From mb-3-cs `adr/14-anvil-extras-exclusion.md` (advisory):
- Anvil Extras is never used in mb-3-cs
- mb5pdlf should follow the same rule — M3 native components only, no extras

---

## 6. Boundary summary

### What is definitively INSIDE the concept

- Three fixed free-text intentions per day
- Two-pass daily cycle (morning set, evening review) driven by state, not clock
- Lock after client-side midnight
- History view (scrollable, no filter, no search)
- Single user, no auth, one table
- Anvil + MD3, no external APIs
- Mobile-first responsive

### What is definitively OUTSIDE the concept

- Streaks, gamification, analytics, reminders, sharing, categories, weekly review
- Authentication, multi-tenancy (for v1)
- Settings screen, onboarding screen
- External API integrations
- Export to markdown (deferred, not rejected)

### What is at the BOUNDARY (needs a decision at a later stage)

| Boundary question | Stage to resolve | Current leaning |
|---|---|---|
| Are morning intentions editable before evening review? | Stage 4 | Leaning: yes, editable until evening review starts |
| Three fixed vs. 1–5 adjustable | Stage 4 | Leaning: three fixed (forces prioritisation) |
| Reflection: required or optional? | Stage 4 | Leaning: optional (concept says "optional") |
| Skip-a-day intentionally | Stage 4 | Leaning: no (honesty — a missed day is a missed day) |
| Morning/evening detection: state-based or clock-based? | Stage 8 | Leaning: state-based (section 1.1 Option B) |
| Lock: client-side or server-side? | Stage 8 | Leaning: client-side date comparison (section 1.2) |
| One table or two? | Stage 4 (concept decision) → Stage 10 (implementation) | Leaning: one table (if three fixed) |
| Switch or checkbox for done toggle? | Stage 13 | Leaning: `m3.Switch` |
| DataGrid or RepeatingPanel for history? | Stage 13 | Leaning: `RepeatingPanel` + `m3.Card` |

---

## BFT checkpoint (Stage 3)

- **Bones:** The bones of this stage are the five pillars from stage 2. The expansion explored each pillar's boundaries: temporal (Pillar 1), data (Pillar 4), interaction (Pillar 3), honesty (Pillar 2), and best-practice (Pillar 5). Key-type bone confirmed: the two-pass cycle is state-based, not clock-based — this is a concept-level insight that simplifies the architecture.
- **Muscle:** Information muscle (cross-project Anvil specs from mb-3-cs) + logic muscle (edge case analysis). The cross-project advisory knowledge (ADR-001) was applied for the first time — it informed the M3 component choices and Anvil Data Tables constraints. All advisory, not canonical.
- **Nerves:** Exploring network (bottom-up expansion tree). Started from concept pillars, expanded into edge cases, scenarios, and best-practice constraints. No achieving or analyzing — this is exploration, not decision.
- **Fat:** The exploration generated a lot of material, but most of it is boundary-mapping, not elaboration. The scenario section (4.1–4.6) could be seen as fat if the scenarios are obvious — but for a test project, documenting them is the point. No fat cut yet — that's stage 5.
- **Skin:** Expanded concept model presented with clear section structure (temporal, data, interaction, scenarios, best-practice, boundary summary). The boundary summary table is the key output — it maps every unresolved question to the stage that will resolve it. Tree structure with the concept at the top.
- **Health:** Good in itself? Yes — the expansion mapped all boundaries and resolved two open questions (first-time-at-3pm → state-based detection; morning/evening detection → state-based). Good for this project? Yes — the scope hasn't expanded; the exploration confirmed the concept is tight. The honesty pillar held up under edge-case pressure (missed days, early reviews, past-midnight).

---

*Stage 3 output. Next: Stage 4 (Concept Definition) — identify the essential working principle: what the concept actually is. Resolve the boundary questions that belong to stage 4.*
