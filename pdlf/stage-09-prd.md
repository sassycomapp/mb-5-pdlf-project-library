# Stage 9 Output — Product Requirements Document (PRD)

**Project:** mb5pdlf (Daily Intentions Tracker)
**Stage:** 9 — Product Planning
**Date:** 2026-06-30
**PDLF phase:** B (Define)

---

## Method

Nerves: Achieving network (purpose → ISCs → user stories → acceptance criteria). The PRD decomposes the concept + architecture into traceable requirements. Each ISC from stage 6 is refined into user stories with acceptance criteria, and traced back to concept decisions and architecture specs.

---

## 1. Ideal State Criteria (ISCs)

Refined from the 6 ISC candidates identified at stage 6. These will be locked at stage 12 (Design Lockdown) into the ISA.

| ISC # | Statement | Verification method | Stage to verify |
|---|---|---|---|
| ISC-1 | Morning form accepts 3 free-text intentions and saves them irrevocably | Manual test: open morning form, type 3 intentions, save → record exists with intentions; attempt to edit → rejected | 15, 17 |
| ISC-2 | Evening form shows 3 read-only intentions, 3 done toggles, optional reflection, and saves | Manual test: open evening form, intentions read-only, toggle done states, type reflection, save → record updated | 15, 17 |
| ISC-3 | Record locks when client-side date changes (past midnight) | Automated test: `should_lock()` returns true for past date; manual test: app after midnight → locked form shown | 15, 17 |
| ISC-4 | History view displays all past records in date-descending order with gaps for missed days | Manual test: create records for day 1 and day 3, skip day 2 → history shows day 3, day 1, gap visible | 16, 17 |
| ISC-5 | Locked records are read-only with "This day is locked" message | Manual test: open app when today is locked → locked form shown, no buttons, message displayed | 17 |
| ISC-6 | App is deployed and accessible via Anvil URL | Deploy to Anvil via GitHub, verify URL loads and responds | 17 |

---

## 2. Functional specification

### FS-1: Startup and state detection

**Description:** When the user opens the app, the startup form (`Form1`) queries the server for today's state. The server returns one of three states: `morning` (no record exists for today), `evening` (record exists, not locked), or `locked` (record exists, locked). The startup form opens the corresponding form.

**Inputs:** None (client sends today's date implicitly via `get_client_today()`).

**Outputs:** Opens `MorningForm`, `EveningForm`, or `LockedForm`.

**Server calls:** `get_today_state()` → `{'success': True, 'data': {'state': '...', 'record': {...}}}`

**Side effects:** `check_and_lock_past_days()` runs before state detection, locking any records with `date < today`.

### FS-2: Morning — set intentions

**Description:** The morning form displays three `m3.TextArea` components (empty) and an "Set intentions" button. The user types three free-text intentions and taps the button. The server creates today's record with the three intentions, all done flags set to false, locked set to false, and timestamps. Upon success, the app transitions to the evening form with the saved record.

**Inputs:** `intention_1` (text, required, non-empty), `intention_2` (text, required, non-empty), `intention_3` (text, required, non-empty).

**Validation:** `validate_intentions(i1, i2, i3)` — all three must be non-empty strings. If any is empty, return `{'success': False, 'error': 'All three intentions are required.'}`.

**Server calls:** `set_intentions(i1, i2, i3)` → `{'success': True, 'data': {'state': 'evening', 'record': {...}}}`

**Errors:**
- Record already exists for today: `{'success': False, 'error': 'Intentions already set for today.'}`
- Validation failed: `{'success': False, 'error': '...'}`

**Irrevocability:** After save, the intentions are not editable. The evening form displays them read-only. There is no "edit intentions" button anywhere in the app.

### FS-3: Evening — review intentions

**Description:** The evening form displays the three intentions (read-only text), three done/not-done toggles (`m3.Switch` — subject to stage 13 confirmation), an optional one-line reflection field (`m3.TextArea`), and a "Save review" button. The user toggles done states, optionally types a reflection, and saves. The server updates today's record with the done states and reflection.

**Inputs:** `done_1` (bool), `done_2` (bool), `done_3` (bool), `reflection` (text, optional, may be empty or None).

**Validation:** `validate_review(d1, d2, d3, reflection)` — done states must be bools. Reflection may be empty/None (optional). If validation fails, return error.

**Server calls:** `save_review(d1, d2, d3, reflection)` → `{'success': True, 'data': {'state': 'evening', 'record': {...}}}`

**Errors:**
- No record for today: `{'success': False, 'error': 'No intentions set for today.'}`
- Record is locked: `{'success': False, 'error': 'Today is locked.'}`

**Re-review:** The user can save the review multiple times before midnight (if the record is not locked). Each save overwrites the previous done states and reflection. After midnight, the record locks and no further saves are possible.

### FS-4: Locked day display

**Description:** When today's record is locked (or any past record is opened), the locked form displays the record read-only: three intentions (with strikethrough if done), three done states (read-only), reflection (if any), and the message "This day is locked." There are no buttons and no save functionality.

**Inputs:** The record data (passed from the startup form's `get_today_state()` response).

**Server calls:** None (data is passed from the state detection call).

### FS-5: History view

**Description:** The history form displays all records in date-descending order. Each record is displayed as an `m3.Card` (subject to stage 13 confirmation) containing: the date, the three intentions (strikethrough if done), and the reflection (if any). Missed days appear as gaps in the list — there is no placeholder row for a missed day.

**Server calls:** `get_history()` → `{'success': True, 'data': [record, ...]}`

**No filter, no search, no pagination.** All records are loaded at once (trivial for <365 rows).

### FS-6: Lock enforcement

**Description:** At app startup, `check_and_lock_past_days()` runs. It queries all records where `locked == False`, compares each record's `date` against today's date (client-provided), and sets `locked = True` for any record where `date < today`.

**Implementation:** Lives in `server_calls.py` (has Anvil imports). Calls `date_logic.is_past_date(record['date'], today)` and `date_logic.should_lock(record, today)` (pure logic).

**Irreversibility:** Once `locked == True`, no code path sets it back to `False`. The `save_review()` function checks `locked` and rejects writes.

---

## 3. User stories

### US-1: Set morning intentions

**As a** user
**I want to** set three intentions for today
**So that** I commit to what I intend to do today

**Acceptance criteria:**
- [ ] AC-1.1: When I open the app and no record exists for today, I see three empty text areas
- [ ] AC-1.2: I can type free text into each of the three areas
- [ ] AC-1.3: The "Set intentions" button is disabled until all three areas have text
- [ ] AC-1.4: When I tap "Set intentions", the record is saved and I transition to the evening view
- [ ] AC-1.5: After saving, I cannot edit the intentions (they are read-only in the evening view)
- [ ] AC-1.6: If I close the app and reopen, I see the evening view (record exists)

**Traces to:** ISC-1, FS-2

### US-2: Review intentions in the evening

**As a** user
**I want to** mark my intentions as done or not-done
**So that** I honestly record what happened today

**Acceptance criteria:**
- [ ] AC-2.1: When I open the app and a record exists for today (not locked), I see the evening view
- [ ] AC-2.2: My three intentions are displayed as read-only text
- [ ] AC-2.3: Each intention has a done/not-done toggle I can switch
- [ ] AC-2.4: There is an optional one-line reflection field
- [ ] AC-2.5: When I tap "Save review", the record is updated with done states and reflection
- [ ] AC-2.6: I can save the review multiple times before midnight (overwrites previous)
- [ ] AC-2.7: After midnight, I cannot save (record is locked)

**Traces to:** ISC-2, FS-3

### US-3: View history

**As a** user
**I want to** see my past days
**So that** I can review my intention-setting over time

**Acceptance criteria:**
- [ ] AC-3.1: I can navigate to the history view via a navigation link
- [ ] AC-3.2: History shows all past records in date-descending order
- [ ] AC-3.3: Each record shows date, three intentions (strikethrough if done), and reflection (if any)
- [ ] AC-3.4: Missed days appear as gaps (no placeholder rows)
- [ ] AC-3.5: There is no filter, no search, and no pagination

**Traces to:** ISC-4, FS-5

### US-4: Encounter a locked day

**As a** user
**I want to** see that a day is locked
**So that** I understand I cannot change it

**Acceptance criteria:**
- [ ] AC-4.1: When I open the app and today's record is locked, I see the locked view
- [ ] AC-4.2: The locked view shows the record read-only (intentions, done states, reflection)
- [ ] AC-4.3: The message "This day is locked." is displayed
- [ ] AC-4.4: There are no buttons or save functionality

**Traces to:** ISC-3, ISC-5, FS-4, FS-6

### US-5: First-time use

**As a** new user
**I want to** start using the app immediately
**So that** I don't have to go through onboarding

**Acceptance criteria:**
- [ ] AC-5.1: When I open the app for the first time, I see the morning view (no record exists)
- [ ] AC-5.2: There is no onboarding screen, tutorial, or welcome message
- [ ] AC-5.3: I can immediately type intentions and save

**Traces to:** ISC-1, FS-1, FS-2

---

## 4. Requirement traceability matrix

| ISC | FS | User story | Acceptance criteria | Concept decision (stage) | Architecture (stage 8) |
|---|---|---|---|---|---|
| ISC-1 | FS-2 | US-1 | AC-1.1–1.6 | Three fixed, free text, irrevocable (4) | `set_intentions()` callable, `validate_intentions()` pure logic (8) |
| ISC-2 | FS-3 | US-2 | AC-2.1–2.7 | Optional reflection, done toggles (4) | `save_review()` callable, `validate_review()` pure logic (8) |
| ISC-3 | FS-6 | US-4 | AC-4.1–4.4 | Lock after midnight (4) | `check_and_lock_past_days()`, `should_lock()` pure logic (8), ADR-003 |
| ISC-4 | FS-5 | US-3 | AC-3.1–3.5 | History with gaps (2, 4) | `get_history()` callable (8) |
| ISC-5 | FS-4 | US-4 | AC-4.1–4.4 | Locked = read-only (4) | `LockedForm` form, `determine_state()` pure logic (8) |
| ISC-6 | — | — | — | Deployable (6) | Anvil deployment via GitHub (7) |

---

## 5. Non-functional requirements

| NFR | Requirement | Source |
|---|---|---|
| Performance | Morning save < 2 seconds; evening save < 2 seconds; history load < 2 seconds | Pre-project: "under 60 seconds" includes human interaction time |
| Usability | Morning flow < 60 seconds; evening flow < 60 seconds | Pre-project constraint |
| Mobile | Responsive on phone screens (375px+ width) | Pre-project constraint |
| Security | No auth (v1); `user_id` column nullable for future | Pre-project constraint |
| Reliability | Lock is irreversible; intentions are irrevocable | Concept decision (4) |
| Maintainability | Pure logic modules unit-testable; response envelope standard | ADR-002, coding standards (8) |

---

## 6. Out of scope (confirmed)

- Authentication / multi-user
- Settings screen
- Onboarding / tutorial
- Streaks, gamification, analytics, reminders
- Export to markdown
- Editing intentions after save
- Skip-a-day
- Search/filter/pagination in history
- External API integrations
- Anvil Extras
- Custom (non-M3) components
- Routing module

---

## BFT checkpoint (Stage 9)

- **Bones:** The bones of this stage are the PCD (stage 6) and the architecture spec (stage 8). The big bones: 6 ISCs, 6 functional specs, 5 user stories with 28 acceptance criteria, the traceability matrix. The key-type bone is the traceability matrix — it proves every ISC traces back to a concept decision and forward to an architecture spec. Without traceability, the PRD is just a list.
- **Muscle:** Logic muscle (decomposition of ISCs into user stories and acceptance criteria). Information muscle (PCD and architecture as inputs). No emotional or habit muscle — requirements are derived from the concept, not from preference.
- **Nerves:** Achieving network (ISC → user story → acceptance criteria → traceability). The PRD decomposes the ISCs downward: each ISC becomes a user story, each story becomes acceptance criteria, each criterion traces back to a concept decision and an architecture spec. This is the Achieving network applied to requirements.
- **Fat:** The functional specs include validation rules and error messages — is this fat? No: these are constraints that stage 15 (feature development) must implement. The user stories include "re-review allowed before midnight" — this is a constraint, not elaboration. No fat detected.
- **Skin:** PRD presented as 6 sections: ISCs, functional specs, user stories, traceability matrix, NFRs, out-of-scope. Tree structure: ISC → FS → US → AC → trace. The traceability matrix is the key reference — it's where the reader verifies completeness.
- **Health:** Good in itself? Yes — every ISC has a functional spec, a user story, acceptance criteria, and traces to concept + architecture. No orphaned requirements. Good for this project? Yes — 6 ISCs, 5 stories, 28 criteria is right for a small app. The PRD is ready to feed stage 10 (Data Design) and stage 12 (Design Lockdown, where ISCs lock into the ISA).

---

*Stage 9 output. Next: Stage 10 (Data Design) — design database/schema. The data model was defined at the concept level (stage 5); stage 10 produces the final Anvil Data Tables schema with column types, validation rules, and naming conventions.*
