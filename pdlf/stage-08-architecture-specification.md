# Stage 8 Output — Architecture Specification

**Project:** mb5pdlf (Daily Intentions Tracker)
**Stage:** 8 — Architecture & Standards
**Date:** 2026-06-30
**PDLF phase:** B (Define)

---

## Method

Bones emphasis: big bones (structural) + key-type bones. Muscle: logic (architecture decisions derived from concept) + value (coding standards). Nerves: Analyzing network (module decomposition). Applied ADR-001 cross-project advisory for the third time — mb-3-cs architecture patterns (pure logic modules, coding standards, server function standards).

---

## 1. Module architecture

### 1.1 Module structure

```
mb5pdlf/
├── client_code/
│   ├── Form1.py                  ← startup form (replaced at stage 14)
│   ├── MorningForm.py            ← morning: 3 text areas, save (irrevocable)
│   ├── EveningForm.py            ← evening: 3 read-only intentions, 3 toggles, reflection, save
│   ├── LockedForm.py             ← locked day: read-only display
│   └── HistoryForm.py            ← history: scrollable RepeatingPanel + m3.Card
├── server_code/
│   ├── __init__.py
│   ├── server_calls.py           ← @anvil.server.callable functions (client-facing)
│   ├── date_logic.py             ← pure logic: client date handling, lock detection
│   └── record_ops.py             ← pure logic: record validation, state determination
├── theme/
│   ├── assets/theme.css          ← CSS Overlay (minimal spacing/typography)
│   ├── parameters.yaml           ← M3 theme parameters
│   └── templates.yaml            ← M3 theme templates
└── anvil.yaml                    ← NEVER WRITE TO THIS
```

### 1.2 Module responsibilities

**Client forms** (4 forms + startup):

| Form | Responsibility | Trigger |
|---|---|---|
| `Form1` (startup) | Calls `get_today_state()`, redirects to Morning/Evening/Locked form | App startup |
| `MorningForm` | 3 `m3.TextArea` + "Set intentions" button. On save: calls `set_intentions()`, transitions to `EveningForm` | State: morning (no record today) |
| `EveningForm` | 3 read-only intentions + 3 done toggles + optional reflection + "Save review" button. On save: calls `save_review()` | State: evening (record exists, not locked) |
| `LockedForm` | Read-only display of locked record + "This day is locked" message. No buttons. | State: locked (record exists, locked) |
| `HistoryForm` | `RepeatingPanel` with `m3.Card` per day. Called from navigation link. | User navigates to History |

**Server modules** (3 modules):

| Module | Responsibility | Pure logic? |
|---|---|---|
| `server_calls.py` | `@anvil.server.callable` functions — the client-facing API. Thin wrapper: validates input, calls pure logic, interacts with `app_tables`, returns response envelope. | No — has Anvil imports (`anvil.server`, `app_tables`) |
| `date_logic.py` | Pure logic: `get_client_today()`, `is_past_date(date)`, `should_lock(record, today)`. No Anvil imports. Unit-testable. | **Yes** — no Anvil imports |
| `record_ops.py` | Pure logic: `determine_state(record)` → "morning"/"evening"/"locked", `validate_intentions(i1, i2, i3)`, `validate_review(d1, d2, d3, reflection)`. No Anvil imports. Unit-testable. | **Yes** — no Anvil imports |

### 1.3 Why pure logic modules (ADR-002)

**Resolved open question: Pure logic modules vs inline logic?**

**Decision: PURE LOGIC MODULES.** Adopted from mb-3-cs `docs/architecture.md` (advisory per ADR-001).

**Rationale:**
- The lock logic (`should_lock`) and state determination (`determine_state`) are the app's critical business logic. They must be testable without an Anvil runtime.
- mb-3-cs uses this pattern: "Pure Logic Modules (no Anvil imports) contain side-effect-free business logic for unit testing. This structure is not a preference. It is what makes the testing strategy work." (mb-3-cs `docs/architecture.md`, advisory)
- For mb5pdlf, the pure logic is small (3 functions in `date_logic`, 3 in `record_ops`), but the pattern is worth establishing — especially for a PDLF test, where the testing strategy is part of what's being tested.
- The `server_calls.py` module is NOT pure — it has Anvil imports and handles `app_tables` interaction. This is the "impure shell" that calls pure logic.

---

## 2. Open question resolutions

### 2.1 Lock enforcement: server-side or client-side? (ADR-003)

**Decision: HYBRID — client-side date detection + server-side lock enforcement.**

**Rationale:**
- The concept (stage 4) said "client-side date comparison." But pure client-side is exploitable (user could modify the client to bypass the lock). For a single-user discipline app, this is self-defeating — but the architecture should still be sound.
- **Client-side:** `get_client_today()` sends the browser's date to the server. This handles timezone correctly without a timezone picker.
- **Server-side:** `check_and_lock_past_days()` runs at app startup (called from `Form1`) and locks any record where `date < today`. The server is the authority — once locked, the `locked` column is `True` and `save_review()` rejects writes.
- **Defense in depth:** the server doesn't trust the client's date for locking — it compares the stored `date` against the client-provided `today`. If the client lies about the date, the lock check still runs against the stored date. The only attack is "set your clock back" — which is self-defeating in a discipline app.

### 2.2 Pure logic modules vs inline logic? (ADR-002)

**Decision: PURE LOGIC MODULES.** See section 1.3 above.

### 2.3 Anvil routing vs startup redirect?

**Decision: STARTUP REDIRECT. No routing dependency.**

**Rationale:**
- The app has 4 forms + 1 startup form. The startup form (`Form1`) calls `get_today_state()` and opens the appropriate form (`MorningForm`, `EveningForm`, or `LockedForm`) via `open_form()`.
- `HistoryForm` is opened via a navigation link (an `m3.NavigationLink` or `m3.IconButton` in the app bar).
- No URL routing needed — there are no deep links, no URL parameters, no bookmarkable views for v1.
- Confirmed at stage 7: no routing dependency installed. This is consistent.

---

## 3. Server function API

Per mb-3-cs `docs/coding-standards.md` (advisory, adopted via ADR-001):

### 3.1 Response envelope

Every `@anvil.server.callable` function returns:
```python
{'success': True, 'data': result}   # on success
{'success': False, 'error': msg}    # on failure
```

### 3.2 Callable functions

| Function | Args | Returns | Side effects |
|---|---|---|---|
| `get_today_state()` | none | `{'success': True, 'data': {'state': 'morning'\|'evening'\|'locked', 'record': {...}}}` | Calls `check_and_lock_past_days()` first |
| `set_intentions(i1, i2, i3)` | 3 strings | `{'success': True, 'data': {'state': 'evening', 'record': {...}}}` | Creates today's record (rejects if exists) |
| `save_review(d1, d2, d3, reflection)` | 3 bools, 1 string (optional) | `{'success': True, 'data': {'state': 'evening', 'record': {...}}}` | Updates today's record (rejects if locked) |
| `get_history()` | none | `{'success': True, 'data': [record, ...]}` | None |

### 3.3 Non-callable functions (internal)

| Function | Module | Purpose |
|---|---|---|
| `get_client_today()` | `date_logic.py` | Returns today's date from client timezone |
| `is_past_date(date, today)` | `date_logic.py` | Pure: is this date before today? |
| `should_lock(record, today)` | `date_logic.py` | Pure: should this record be locked? |
| `determine_state(record)` | `record_ops.py` | Pure: morning/evening/locked from record |
| `validate_intentions(i1, i2, i3)` | `record_ops.py` | Pure: are intentions valid? (non-empty) |
| `validate_review(d1, d2, d3, reflection)` | `record_ops.py` | Pure: is the review valid? |
| `check_and_lock_past_days()` | `server_calls.py` | Locks past records (server-side, has Anvil imports) |

---

## 4. Data flow

```
User opens app
  → Form1 (startup)
    → server_calls.get_today_state()
      → date_logic.get_client_today() → today
      → check_and_lock_past_days() → locks any date < today
      → app_tables.intentions.get(date=today) → record (or None)
      → record_ops.determine_state(record) → "morning" / "evening" / "locked"
      → return {state, record}
    → Form1 opens appropriate form:
      → MorningForm (state=morning)
        → user types 3 intentions
        → user taps "Set intentions"
        → server_calls.set_intentions(i1, i2, i3)
          → record_ops.validate_intentions(i1, i2, i3) → valid?
          → app_tables.intentions.get(date=today) → exists? reject
          → app_tables.intentions.add_row(...)
          → return {state: evening, record}
        → open_form(EveningForm, record)
      → EveningForm (state=evening)
        → display 3 intentions (read-only), 3 toggles, reflection field
        → user toggles done/not-done, types reflection
        → user taps "Save review"
        → server_calls.save_review(d1, d2, d3, reflection)
          → record_ops.validate_review(d1, d2, d3, reflection) → valid?
          → app_tables.intentions.get(date=today) → record
          → record['locked'] → True? reject
          → update record (done_1/2/3, reflection, updated_at)
          → return {state: evening, record}
        → confirmation: "Review saved."
      → LockedForm (state=locked)
        → display record read-only + "This day is locked."
        → no buttons, no save
  → HistoryForm (via navigation)
    → server_calls.get_history()
      → app_tables.intentions.search(order_by('date', descending=True))
      → return list of records
    → RepeatingPanel renders m3.Card per record
```

---

## 5. Coding standards

Adopted from mb-3-cs `docs/coding-standards.md` (advisory per ADR-001). These are advisory patterns adopted for mb5pdlf — not inherited as constraints, but chosen because they're good practice and consistent with the platform.

### 5.1 Anvil-first principle
Default to Anvil's built-in facilities. Custom implementations require documented justification. (Adopted from mb-3-cs.)

### 5.2 Server function standards
- Response envelope: `{'success': bool, 'data'/'error': ...}` (section 3.1)
- Docstrings: every server function has Args, Returns, Raises sections
- Type hints: required on all public functions

### 5.3 Pure logic module standards
- No `anvil.*` imports in `date_logic.py` or `record_ops.py`
- Side-effect-free: no I/O, no `app_tables` access
- Functions take primitives (dates, strings, bools, dicts) and return primitives
- Unit-testable without an Anvil runtime

### 5.4 Naming conventions
- Forms: `PascalCase` (`MorningForm`, `EveningForm`)
- Server modules: `snake_case` (`server_calls.py`, `date_logic.py`)
- Functions: `snake_case` (`get_today_state`, `set_intentions`)
- Data Tables columns: `snake_case` (`intention_1`, `done_1`, `created_at`)
- Variables: `snake_case`

### 5.5 Error handling
- Server functions return `{'success': False, 'error': msg}` for expected errors (record exists, locked, validation failed)
- Server functions raise exceptions for unexpected errors (database failure, programming error)
- Client forms display the error message from the response envelope

---

## 6. Architecture constraints

| Constraint | Value | Source |
|---|---|---|
| Pure logic modules have no Anvil imports | `date_logic.py`, `record_ops.py` | ADR-002 |
| Server functions use response envelope | `{'success': bool, ...}` | mb-3-cs coding standards (adopted) |
| Lock is server-enforced | `check_and_lock_past_days()` runs at startup | ADR-003 |
| Intentions are irrevocable | `set_intentions()` rejects if record exists | Concept decision (stage 4) |
| No editing of locked records | `save_review()` rejects if `locked == True` | Concept decision (stage 4) |
| anvil.yaml is never written | Hard rule | AGENTS.md |
| M3 native components only | No custom components | Stage 7 + ADR-001 |
| No Anvil Extras | Never used | Stage 7 + ADR-001 |
| No external APIs | Self-contained | Pre-project constraint |

---

## 7. Testing strategy

| Layer | Test type | Tool | What's tested |
|---|---|---|---|
| `date_logic.py` | Unit tests | Python `unittest` (no Anvil needed) | `get_client_today()`, `is_past_date()`, `should_lock()` |
| `record_ops.py` | Unit tests | Python `unittest` (no Anvil needed) | `determine_state()`, `validate_intentions()`, `validate_review()` |
| `server_calls.py` | Integration | Manual (Anvil runtime required) | All 4 callable functions |
| Forms | Manual QA | `/qa` GStack skill (stage 16) | All 4 forms + startup redirect |

The pure logic modules are the testable core. The server calls and forms require an Anvil runtime and are tested manually or via GStack's `/qa` skill at stage 16.

---

## 8. ADRs created this stage

| ADR | Title | Decision |
|---|---|---|
| ADR-002 | Pure Logic Module Architecture | Adopt pure logic modules (no Anvil imports) for `date_logic.py` and `record_ops.py` |
| ADR-003 | Lock Enforcement Strategy | Hybrid: client-side date detection + server-side lock enforcement |

---

## BFT checkpoint (Stage 8)

- **Bones:** The bones of this stage are the PCD (stage 6) and the stack (stage 7). The big bones: 5 client forms, 3 server modules, 4 server callables, 6 pure logic functions, the data flow diagram, the coding standards. The key-type bone is the pure logic module pattern — it separates testable logic from Anvil-dependent code, making the testing strategy possible.
- **Muscle:** Logic muscle (architecture decisions derived from concept decisions). Value muscle (coding standards adopted from mb-3-cs because they're good practice). Channel muscle (mb-3-cs patterns as existing channels — adopted via ADR-001). Information muscle (mb-3-cs specs). No emotional or habit muscle — every decision is derived from the concept or adopted from advisory with explicit reasoning.
- **Nerves:** Analyzing network (top-down decomposition: app → modules → functions). The module structure is a classification (client forms vs server modules vs pure logic). The data flow is an Achieving network (goal → steps → detail).
- **Fat:** The coding standards section is muscle (it constrains stages 15–16), not fat. The data flow diagram is muscle (it's the operational specification). What was cut: no deployment pipeline details (stage 16), no UI component specifications (stage 13), no test code (stage 15). The architecture is specified, not over-specified.
- **Skin:** 8-section architecture specification. Tree structure: modules → open questions → API → data flow → standards → constraints → testing → ADRs. Reference document for stages 10–16. Up-front: module structure diagram.
- **Health:** Good in itself? Yes — the architecture is complete (all modules defined), testable (pure logic separated), and sound (lock is server-enforced, intentions are irrevocable). Good for this project? Yes — the scope is right (5 forms, 3 modules, 4 callables — small but real). The pure logic pattern is worth testing as part of the PDLF test. The ADR-001 advisory was applied for the third time, each time with explicit adoption notes.

---

*Stage 8 output. Next: Stage 9 (Product Planning) — develop PRD and supporting planning documents. The architecture spec feeds the PRD's technical sections.*
