# Stage 10 Completion Report — Data Design

**Project:** mb5pdlf
**Stage:** 10 — Data Design
**PDLF Phase:** B (Define)
**Date:** 2026-06-30
**Duration:** 1 session
**Status:** Complete

## 1. Purpose
Design the database/schema. Per PDLF, this stage produces table structures, column definitions, data types, relationships, validation rules, naming conventions, and a security model. The data model was defined at concept level (stage 5: 1 table, 12 columns); stage 10 produces the definitive Anvil Data Tables schema.

## 2. Inputs
- `pdlf/stage-05-distilled-concept-document.md` — data model (1 table, 12 columns)
- `pdlf/stage-08-architecture-specification.md` — module structure, server API, pure logic functions
- `pdlf/stage-09-prd.md` — functional specs (validation rules, error messages)
- `adr/001-cross-project-anvil-knowledge-reuse.md` — cross-project advisory
- mb-3-cs `docs/anvil-spec-table.md` section 4 (advisory) — Data Tables patterns
- mb-3-cs `docs/coding-standards.md` (advisory) — naming conventions
- mb-3-cs `docs/authoritative-schema.md` (advisory) — schema documentation format

## 3. Work performed

### 3.1 Table definition
Defined the `intentions` table with 12 columns:
- `date` (date, unique, required) — primary lookup key
- `intention_1/2/3` (text, required, max 500 chars) — morning intentions, irrevocable
- `done_1/2/3` (bool, required, default false) — evening review
- `reflection` (text, optional, max 500 chars) — one-line evening reflection
- `locked` (bool, required, default false) — lock flag, irreversible once true
- `user_id` (text, nullable) — future-proofing, always None in v1
- `created_at` / `updated_at` (datetime, required) — audit timestamps

### 3.2 Anvil Data Tables configuration
- Client access: None (server-side only) — adopted from mb-3-cs advisory
- Row ID: Anvil built-in (`row.get_id()`) — no custom auto-increment
- No row-level security (single user, no auth for v1)
- No relationships (single table)

### 3.3 Validation rules
Defined 6 validation rules enforced in pure logic modules (`record_ops.py`) and server calls (`server_calls.py`): non-empty intentions, max 500 chars, bool done states, optional reflection, locked check, duplicate check.

### 3.4 Naming conventions
Adopted snake_case for table and column names from mb-3-cs (advisory). Datetime columns use `_at` suffix. Noted deliberate deviation: `user_id` instead of mb-3-cs's `instance_id` pattern (mb5pdlf is single-user, not multi-tenant).

### 3.5 Security model
Defined access control (client: none, server: full), lock security (irreversible, enforced in `save_review()` and `check_and_lock_past_days()`), and irrevocability security (date uniqueness + no update path for intentions).

### 3.6 Query patterns
Defined 3 query patterns: get-by-date (O(1)), list-all-descending (O(n)), find-unlocked-past (O(n)). No joins, no aggregations.

### 3.7 Migration strategy
No migration tool (per ADR-001 advisory). Schema must be right at creation. `user_id` included at creation to avoid future migration. Table created in Anvil editor at stage 14.

### 3.8 ADR-001 applied (fourth use)
Applied mb-3-cs Data Tables patterns: client access = None (adopted), Row ID (adopted), no custom auto-increment (adopted), `instance_id` pattern (NOT adopted — deliberate deviation, noted).

## 4. Outputs (artifacts produced)

| Artifact | Path | Description |
|---|---|---|
| Data model | `pdlf/stage-10-data-model.md` | 7-section schema: table, columns, naming, security, queries, lifecycle, migration, advisory |
| Devlog entry 12 | `pdlf/devlog.md` | Stage 10 entry |
| State file | `~/.gstack/projects/mb5pdlf/pdlf-state.md` | Updated: stage 10, substep "data-designed" |

## 5. Decisions made

| Decision | Rationale | ADR? |
|---|---|---|
| Client access = None for intentions table | Adopted from mb-3-cs advisory. All access via server callables. | No — adopted from ADR-001 |
| Use built-in Row ID (no custom auto-increment) | Adopted from mb-3-cs advisory. | No — adopted from ADR-001 |
| `user_id` instead of `instance_id` | mb5pdlf is single-user, not multi-tenant. Deliberate deviation noted. | No — deviation from ADR-001 advisory |
| Max 500 chars per intention/reflection | Prevents excessively long entries; 500 chars is ~2-3 sentences | No — design decision |
| Date uniqueness enforced application-side | Anvil Data Tables doesn't enforce unique constraints. `set_intentions()` rejects duplicates. | No — implementation detail |
| No deletion, no export for v1 | Honesty pillar — can't rewrite history. Export is deferred (not rejected). | No — concept decision |

## 6. Open questions still deferred

| Question | Deferred to stage | Leaning |
|---|---|---|
| `m3.Switch` vs `m3.Checkbox` for done toggle? | 13 | `m3.Switch` |
| `RepeatingPanel`+`m3.Card` vs `DataGrid` for history? | 13 | `RepeatingPanel` + `m3.Card` |

## 7. BFT checkpoint summary
- Bones: big bone = `intentions` table. Key-type = `date` unique constraint (enforces irrevocability + primary lookup).
- Muscle: logic (column types from concept) + information (mb-3-cs advisory, ADR-001) + value (naming conventions) + channel (Anvil Data Tables).
- Nerves: Analyzing (decomposition into columns, each with type/constraint/purpose).
- Fat: `user_id` is not fat (future-proofing constraint). Deviation note is muscle. No fat.
- Skin: 7-section data model. Tree structure. Reference for stages 14-15.
- Health: good — complete, correct, constrained. Lock and irrevocability enforced at data level.

## 8. Gate status
No gate — next gate at stage 12 (stage-12-locked).

## 9. Next stage
Stage 11 (Design Sanity Audit) — validate consistency, feasibility, simplicity, and fit-for-purpose across all prior stage outputs. Architecture review, UX review, risk assessment, complexity analysis, constraint validation, technical feasibility checks. This is the last stage before lockdown.

## 10. Maintenance performed
**Stage 10 maintenance run** per SKILL.md section 6.4 ("End of stage 10 — data design committed — docs repo only — code repo unchanged"). See below.
