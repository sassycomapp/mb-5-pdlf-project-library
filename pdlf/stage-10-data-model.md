# Stage 10 Output — Data Model

**Project:** mb5pdlf (Daily Intentions Tracker)
**Stage:** 10 — Data Design
**Date:** 2026-06-30
**PDLF phase:** B (Define)

---

## Method

Bones emphasis: key-type big bone (the single table). Applied ADR-001 advisory for the fourth time — mb-3-cs Anvil Data Tables patterns (Row ID, client access rules, linking). The data model was defined at concept level (stage 5: 1 table, 12 columns); stage 10 produces the definitive Anvil Data Tables schema with column types, validation rules, naming conventions, and security model.

---

## 1. Table: `intentions`

### 1.1 Purpose
Stores one record per day: three morning intentions, three evening done states, optional reflection, lock flag, and audit timestamps. The only table in v1.

### 1.2 Anvil Data Tables configuration

| Property | Value | Source |
|---|---|---|
| Table name | `intentions` | Concept decision (stage 5) |
| Client access | **None** (server-side only) | ADR-001 advisory (mb-3-cs `docs/anvil-spec-table.md` section 4.1: "All tables set to No access for client code") |
| Row ID | Anvil built-in (`row.get_id()`) | ADR-001 advisory (mb-3-cs: "Use built-in Row ID via row.get_id()") |
| Custom auto-increment | No | ADR-001 advisory (mb-3-cs: "Never create unless explicit human-readable ID required") |
| Multi-tenancy | No for v1 (single user, no auth) | Pre-project constraint |
| Relationships | None (single table) | Concept decision (stage 4: one table) |

### 1.3 Column definitions

| # | Column name | Anvil type | Required | Default | Validation | Notes |
|---|---|---|---|---|---|---|
| 1 | `date` | date | Yes | — | Unique (one record per day); must be a valid date | The primary lookup key. `app_tables.intentions.get(date=today)` |
| 2 | `intention_1` | text | Yes | — | Non-empty string; max 500 chars | Free text, set in morning, not editable after save |
| 3 | `intention_2` | text | Yes | — | Non-empty string; max 500 chars | Same |
| 4 | `intention_3` | text | Yes | — | Non-empty string; max 500 chars | Same |
| 5 | `done_1` | bool | Yes | `False` | Must be bool | Set in evening; default false |
| 6 | `done_2` | bool | Yes | `False` | Must be bool | Same |
| 7 | `done_3` | bool | Yes | `False` | Must be bool | Same |
| 8 | `reflection` | text | No | `None` | Max 500 chars; may be empty or None | Optional one-line reflection, set in evening |
| 9 | `locked` | bool | Yes | `False` | Must be bool; once True, never set back to False | Set by `check_and_lock_past_days()` when date < today |
| 10 | `user_id` | text | No | `None` | Nullable; no validation for v1 | Future-proofing — no auth implementation. Always None in v1. |
| 11 | `created_at` | datetime | Yes | — | Must be datetime | Set at record creation (`anvil.server.now()`) |
| 12 | `updated_at` | datetime | Yes | — | Must be datetime | Set at record creation and updated on every save |

### 1.4 Unique constraint

The `date` column must be unique — one record per day. Anvil Data Tables does not enforce unique constraints at the schema level. Enforcement is application-side:

```python
# In server_calls.py — set_intentions()
if app_tables.intentions.get(date=today) is not None:
    return {'success': False, 'error': 'Intentions already set for today.'}
```

This is the irrevocability guard — the only way to create a record is `set_intentions()`, which rejects if a record already exists.

### 1.5 Validation rules (enforced in pure logic modules)

| Rule | Function | Module | Error message |
|---|---|---|---|
| All 3 intentions must be non-empty | `validate_intentions(i1, i2, i3)` | `record_ops.py` | "All three intentions are required." |
| Each intention max 500 chars | `validate_intentions(i1, i2, i3)` | `record_ops.py` | "Intentions must be 500 characters or fewer." |
| Done states must be bools | `validate_review(d1, d2, d3, reflection)` | `record_ops.py` | "Done states must be true or false." |
| Reflection max 500 chars | `validate_review(d1, d2, d3, reflection)` | `record_ops.py` | "Reflection must be 500 characters or fewer." |
| Cannot save to locked record | `save_review()` checks `record['locked']` | `server_calls.py` | "Today is locked." |
| Cannot create duplicate record | `set_intentions()` checks existing | `server_calls.py` | "Intentions already set for today." |

---

## 2. Naming conventions

Adopted from mb-3-cs `docs/coding-standards.md` and `docs/nomenclature.md` (advisory via ADR-001):

| Element | Convention | Example | Source |
|---|---|---|---|
| Table name | `snake_case` | `intentions` | mb-3-cs (advisory) |
| Column name | `snake_case` | `intention_1`, `created_at` | mb-3-cs (advisory) |
| Bool columns | prefix `is_` or descriptive verb | `locked` (not `is_locked`) | mb-3-cs uses both; `locked` is simpler for a single-table app |
| Date columns | `snake_case` with no suffix | `date` (not `intention_date`) | Simplified for single-table app |
| Datetime columns | `_at` suffix | `created_at`, `updated_at` | mb-3-cs (advisory) |

### Deviation from mb-3-cs advisory

mb-3-cs uses `instance_id` for multi-tenancy. mb5pdlf uses `user_id` (nullable, no auth for v1). This is a deliberate deviation — mb5pdlf is single-user, not multi-tenant. The column exists for future-proofing but is not an `instance_id` pattern. Noted per ADR-001 cross-contamination discipline: "Pattern NOT adopted — mb5pdlf is single-user, not multi-tenant."

---

## 3. Security model

### 3.1 Access control

| Layer | Access | Rationale |
|---|---|---|
| Client code | **No access** to `intentions` table | Adopted from mb-3-cs advisory. All data access via server callables only. |
| Server code | Full access to `intentions` table | Standard Anvil pattern — server modules access `app_tables` directly. |
| Row-level security | Not needed for v1 | Single user, no auth. Future: filter by `user_id` when auth is added. |

### 3.2 Lock security

The `locked` column is the security boundary for immutability:
- Once `locked == True`, no server function modifies the record.
- `save_review()` checks `locked` before any write.
- `check_and_lock_past_days()` is the only function that sets `locked = True`.
- No function sets `locked = False`. The lock is irreversible.

### 3.3 Irrevocability security

The `date` unique constraint (application-enforced) is the security boundary for irrevocability:
- `set_intentions()` rejects if a record exists for today's date.
- No function updates `intention_1`, `intention_2`, or `intention_3` after creation.
- The evening form displays intentions as read-only — no client-side edit path exists.

---

## 4. Query patterns

| Query | Code | Used in | Performance |
|---|---|---|---|
| Get today's record | `app_tables.intentions.get(date=today)` | `get_today_state()`, `set_intentions()`, `save_review()` | O(1) with date index |
| Get all records (history) | `app_tables.intentions.search(tables.order_by("date", descending=True))` | `get_history()` | O(n) — trivial for <365 rows |
| Find unlocked past records | `app_tables.intentions.search(q.fetch_only("date", "locked"), q.like("locked", False))` | `check_and_lock_past_days()` | O(n) — runs once at startup |

No complex queries. No joins (single table). No aggregations. The data access pattern is the simplest possible: get-by-date, list-all, and find-and-lock.

---

## 5. Data lifecycle

| Event | What happens | Who triggers |
|---|---|---|
| Record created | `set_intentions()` adds a row with intentions, done=false, locked=false, timestamps | User (morning save) |
| Record updated (review) | `save_review()` updates done_1/2/3, reflection, updated_at | User (evening save) |
| Record locked | `check_and_lock_past_days()` sets locked=true when date < today | System (startup) |
| Record deleted | Never (no UI deletion, no server function for deletion) | Nobody |
| Record exported | Never (no export for v1) | N/A |

Records are create-and-eventually-lock. No update after lock. No deletion. This is the simplest possible lifecycle.

---

## 6. Migration strategy

**There is no migration tool for Anvil Data Tables** (ADR-001 advisory from mb-3-cs `docs/anvil-spec-table.md`). The schema must be right at creation.

For v1: the table is created in the Anvil editor (stage 14) with the 12 columns defined above. If a column needs to be added later, it is added manually in the Anvil editor. If a column needs to be removed or renamed, existing data must be migrated manually (export, modify, re-import — Anvil supports CSV import/export).

For v1, no migration is needed — the table is created fresh. The `user_id` column is included at creation to avoid a future migration when auth is added.

---

## 7. Cross-project advisory applied (per ADR-001)

| mb-3-cs source | What was applied | Status |
|---|---|---|
| `docs/anvil-spec-table.md` section 4.1 | Client access = None; use built-in Row ID; never create custom auto-increment | **Adopted** |
| `docs/anvil-spec-table.md` section 4.3 | Store Row objects for relationships (not integer IDs) | **Not applicable** (single table, no relationships) |
| `docs/anvil-spec-table.md` section 4.1 | Multi-tenancy via `instance_id` on every table | **NOT adopted** — mb5pdlf is single-user, not multi-tenant. `user_id` column used instead (nullable, no auth). Deviation noted. |
| `docs/coding-standards.md` | Naming conventions (snake_case tables/columns) | **Adopted** |
| `docs/nomenclature.md` | Column naming patterns | **Adopted** (simplified for single-table app) |
| `docs/authoritative-schema.md` | Schema documentation format | **Adopted** (column table format) |

---

## BFT checkpoint (Stage 10)

- **Bones:** The bones of this stage are the concept's data model (stage 5: 1 table, 12 columns) and the architecture's module structure (stage 8: server_calls + pure logic). The big bone is the `intentions` table itself. The key-type bone is the `date` unique constraint — it enforces irrevocability (one record per day, no duplicates) and is the primary lookup key.
- **Muscle:** Logic muscle (column types and validation rules derived from concept decisions). Information muscle (mb-3-cs Data Tables patterns via ADR-001). Value muscle (naming conventions adopted from mb-3-cs because they're good practice). Channel muscle (Anvil Data Tables as the existing data layer — no external DB needed). No emotional or habit muscle — every column traces to a concept decision.
- **Nerves:** Analyzing network (decomposition of the table into columns, each with type, validation, and purpose). The column table is a classification: each column is a "bone" of the data model, analyzed for type, constraint, and lifecycle.
- **Fat:** The `user_id` column — is it fat for v1? No: it's a constraint (future-proofing per the pre-project constraints doc). It costs nothing (nullable, always None) and avoids a migration when auth is added. The deviation note (not adopting `instance_id` pattern) is muscle — it records a deliberate design decision. No fat detected.
- **Skin:** 7-section data model document. Tree structure: table → columns → constraints → naming → security → queries → lifecycle → migration. Reference document for stage 14 (table creation in Anvil editor) and stage 15 (feature development).
- **Health:** Good in itself? Yes — the schema is complete (12 columns cover all concept requirements), correct (types match Anvil Data Tables capabilities), and constrained (no unnecessary columns, no relationships, no migration tool needed). Good for this project? Yes — one table is the simplest possible data model. The lock and irrevocability are enforced at the data level (locked column, date uniqueness), not just at the code level.

---

*Stage 10 output. Next: Stage 11 (Design Sanity Audit) — validate consistency, feasibility, simplicity, and fit-for-purpose. Architecture review, UX review, risk assessment, complexity analysis, constraint validation, technical feasibility checks.*
