# Stage 6 Output — Project Concept Document (PCD)

**Project:** mb5pdlf (Daily Intentions Tracker)
**Stage:** 6 — Project Framing
**Date:** 2026-06-30
**PDLF phase:** B (Define) — first stage

---

## PCD Method

Muscle emphasis: purpose decomposition (overall objectives → sub-objectives). Nerves: Achieving network (purpose → broad concepts → means → detail). Input: the distilled concept document (stage 5). The PCD converts the concept into operational form: goals, user flows, workflows, scope, outcomes.

---

## 1. Project goals

### Overall objective
Ship a deployable v1 of the Daily Intentions Tracker — a single-user Anvil+MD3 web app with a two-pass daily discipline cycle — in a few focused sessions, as a test of the PDLF workflow.

### Sub-objectives (hierarchy)

| # | Sub-objective | Serves | Stage(s) |
|---|---|---|---|
| 1 | Define the data model (one table, 12 columns) | Overall | 10 |
| 2 | Define the architecture (server modules, lock logic, state-based detection) | Overall | 8 |
| 3 | Build the morning form (3 text areas, save, irrevocable) | Overall | 14–15 |
| 4 | Build the evening form (3 read-only intentions, 3 done toggles, optional reflection, save) | Overall | 14–15 |
| 5 | Build the history view (scrollable, RepeatingPanel + m3.Card) | Overall | 14–15 |
| 6 | Implement the lock-after-midnight logic (client-side date comparison) | Overall | 15 |
| 7 | Implement the state-based morning/evening detection | Overall | 15 |
| 8 | Deploy to Anvil via GitHub | Overall | 16–17 |
| 9 | Complete the PDLF LEARN junction (stage 17b) honestly | Overall (test objective) | 17b |

### Parallel objectives
- Ship a working app (technical)
- Test whether PDLF adds value (process)

These are parallel, not alternative. The app must work AND the PDLF test must produce an honest assessment.

---

## 2. User flows

### Flow 1: Morning — set intentions

```
User opens app (root URL)
  → startup module checks: does a record exist for today's date?
    → NO record → morning mode
      → display 3 empty m3.TextArea components
      → user types 3 intentions
      → user taps "Set intentions" (m3.Button, filled)
      → server saves record (date, intention_1/2/3, done_1/2/3=false, locked=false)
      → app transitions to evening mode (intentions now read-only)
      → confirmation: "Intentions set."
    → record EXISTS, not locked → evening mode (see Flow 2)
    → record EXISTS, locked → locked view (see Flow 3)
```

**Key interaction rule:** Once "Set intentions" is tapped, the intentions are irrevocable. The text areas become read-only. There is no "edit" button.

### Flow 2: Evening — review intentions

```
User opens app (root URL)
  → startup module checks: does a record exist for today's date?
    → record EXISTS, not locked → evening mode
      → display 3 intentions (read-only text)
      → display 3 done toggles (m3.Switch or m3.Checkbox — deferred to stage 13)
      → display optional reflection field (m3.TextArea, single line)
      → user toggles done/not-done for each intention
      → user optionally types a reflection
      → user taps "Save review" (m3.Button, filled)
      → server updates record (done_1/2/3, reflection)
      → confirmation: "Review saved."
    → NO record → morning mode (see Flow 1)
    → record EXISTS, locked → locked view (see Flow 3)
```

### Flow 3: Locked day

```
User opens app (root URL)
  → startup module checks: does a record exist for today's date?
    → record EXISTS, locked → locked view
      → display 3 intentions (read-only)
      → display 3 done states (read-only, not toggleable)
      → display reflection (read-only, if any)
      → display message: "This day is locked."
      → no save button, no edit controls
```

**Note:** The locked state only applies to past days. Today's record locks at client-side midnight. A user opening the app after midnight sees today's (new) morning mode, not yesterday's locked record.

### Flow 4: History

```
User navigates to History (via navigation link or URL)
  → server fetches all records ordered by date descending
  → display scrollable list (RepeatingPanel + m3.Card per day)
    → each card: date, 3 intentions (strikethrough if done), reflection (if any)
    → gaps in dates are visible (missed days show as gaps, not as empty records)
  → no filter, no search, no pagination (for v1)
```

### Flow 5: First-time use

```
User opens app for the first time ever
  → no records exist in the database
  → no record for today
  → morning mode (identical to Flow 1)
  → no onboarding screen, no tutorial, no welcome
```

---

## 3. Operational workflows

### Workflow A: Server — get today's record

```python
@anvil.server.callable
def get_today_state():
    """Returns the current state for today's date.
    State is one of: 'morning', 'evening', 'locked'
    """
    today = get_client_today()  # client-side date
    record = app_tables.intentions.get(date=today)
    if record is None:
        return {'state': 'morning', 'record': None}
    elif record['locked']:
        return {'state': 'locked', 'record': record}
    else:
        return {'state': 'evening', 'record': record}
```

### Workflow B: Server — save morning intentions

```python
@anvil.server.callable
def set_intentions(intention_1, intention_2, intention_3):
    """Creates today's record with 3 intentions. Not editable after save."""
    today = get_client_today()
    # Guard: if record already exists, reject (intentions are irrevocable)
    if app_tables.intentions.get(date=today) is not None:
        raise ValueError("Intentions already set for today.")
    record = app_tables.intentions.add_row(
        date=today,
        intention_1=intention_1,
        intention_2=intention_2,
        intention_3=intention_3,
        done_1=False,
        done_2=False,
        done_3=False,
        reflection=None,
        locked=False,
        user_id=None,
        created_at=anvil.server.now(),
        updated_at=anvil.server.now(),
    )
    return {'state': 'evening', 'record': record}
```

### Workflow C: Server — save evening review

```python
@anvil.server.callable
def save_review(done_1, done_2, done_3, reflection=None):
    """Updates today's record with done states and optional reflection."""
    today = get_client_today()
    record = app_tables.intentions.get(date=today)
    if record is None:
        raise ValueError("No intentions set for today.")
    if record['locked']:
        raise ValueError("Today is locked.")
    record['done_1'] = done_1
    record['done_2'] = done_2
    record['done_3'] = done_3
    record['reflection'] = reflection
    record['updated_at'] = anvil.server.now()
    return {'state': 'evening', 'record': record}
```

### Workflow D: Server — lock check (scheduled or on-access)

```python
def check_and_lock_past_days():
    """Locks any records where the date is before today.
    Called at app startup or via scheduled task.
    """
    today = get_client_today()
    old_records = app_tables.intentions.search(
        q.fetch_only("date", "locked"),
        q.like("locked", False)
    )
    for record in old_records:
        if record['date'] < today:
            record['locked'] = True
```

### Workflow E: Server — get history

```python
@anvil.server.callable
def get_history():
    """Returns all records ordered by date descending."""
    records = app_tables.intentions.search(tables.order_by("date", descending=True))
    return list(records)
```

---

## 4. Scope

### In scope (v1)

- Morning form: 3 text areas, save, irrevocable
- Evening form: 3 read-only intentions, 3 done toggles, optional reflection, save
- History view: scrollable list of past days
- Lock-after-midnight (client-side date comparison)
- State-based morning/evening detection
- Single table, 12 columns
- No auth, no users table
- Anvil + MD3 native components only
- Mobile-first responsive

### Out of scope (v1)

- Authentication / multi-user
- Settings screen
- Onboarding / tutorial
- Streaks, gamification, analytics, reminders
- Export to markdown
- Editing intentions after save
- Skip-a-day
- Search/filter in history
- Pagination in history (load all)
- External API integrations
- Anvil Extras
- Custom (non-M3) components

### Future (post-v1, not designed)

- Multi-user with auth
- Adjustable intention count (would require concept change)
- Export to markdown
- Weekly review
- API for external access

---

## 5. Outcomes

### Success criteria

| # | Criterion | How to verify |
|---|---|---|
| 1 | User can set 3 intentions in under 60 seconds | Manual test: time the morning flow |
| 2 | User can review 3 intentions in under 60 seconds | Manual test: time the evening flow |
| 3 | Intentions are not editable after first save | Automated test: attempt to edit after save → rejected |
| 4 | Records lock after client-side midnight | Automated test: simulate date change → record locks |
| 5 | History shows past days with gaps for missed days | Manual test: skip a day → gap visible in history |
| 6 | App is deployable to Anvil via GitHub | Deploy to Anvil, verify URL works |
| 7 | PDLF LEARN junction completed honestly | Stage 17b produces an honest assessment |

### ISC candidates (for stage 12 ISA)

These will become ISCs at stage 12 (Design Lockdown). Listed here as candidates:

- ISC-1: Morning form accepts 3 free-text intentions and saves them irrevocably
- ISC-2: Evening form shows 3 read-only intentions, 3 done toggles, optional reflection, and saves
- ISC-3: Record locks when client-side date changes (past midnight)
- ISC-4: History view displays all past records in date-descending order with gaps for missed days
- ISC-5: Locked records are read-only with "This day is locked" message
- ISC-6: App is deployed and accessible via Anvil URL

---

## 6. Open question from stage 3 (assigned to stage 6)

### Q: What happens if the user opens the app for the first time at 3pm?

**Resolution (confirmed from stage 3):** State-based detection handles this. At 3pm with no record for today, the app shows morning mode. The user sets intentions at 3pm — late but valid. Better late than never. The concept's "morning" means "no intentions set yet," not "before 12:00."

**No additional design needed** — the state-based detection from stage 3 handles this. The PCD confirms this in Flow 1 and Flow 5.

---

## BFT checkpoint (Stage 6)

- **Bones:** The bones of this stage are the distilled concept (stage 5) and its 5 pillars. The big bones of the PCD: the 5 user flows, the 5 server workflows, the scope table, the success criteria. The key-type bone is the state-based detection (it determines the entire startup flow).
- **Muscle:** Muscle (purpose) — the overall objective was decomposed into 9 sub-objectives. Information muscle (the distilled concept provided the facts). Logic muscle (the user flows are logically derived from the concept decisions). No emotional or habit muscle — the PCD is operational, not opinion.
- **Nerves:** Achieving network (purpose → sub-objectives → means → detail). The user flows are backward-planned from the goal ("user sets intentions" → "what must exist for this to happen" → "server saves record" → "Data Tables schema"). The server workflows are the "means" level. The UI details (deferred to stage 13) are the "detail" level.
- **Fat:** The server workflows include Python pseudocode — is this fat at the framing stage? No: pseudocode clarifies the operational workflow without committing to implementation. The actual Python will be written at stage 15. The pseudocode is muscle (it shows the logic), not fat. What WAS cut: no API design (no external consumers), no deployment pipeline details (deferred to stage 16), no test strategy details (deferred to stage 12 ISA).
- **Skin:** PCD presented as 6 numbered sections (goals, flows, workflows, scope, outcomes, open question). Tree structure: goals → flows → workflows → scope. Up-front: overall objective stated first. Communication triad: why read it (to understand the operational form), where is the reader (entering Phase B), what is wanted (a PCD that feeds stages 7–12).
- **Health:** Good in itself? Yes — the PCD is operational, specific, and testable. Every flow traces to a concept decision. Every workflow traces to a flow. Good for this project? Yes — the scope is tight, the flows are simple (5 flows, 5 server calls), and the timeline is achievable. The ISC candidates will feed directly into the ISA at stage 12.

---

*Stage 6 output. Next: Stage 7 (Platform & Framework Selection) — define execution environment and foundational stack.*
