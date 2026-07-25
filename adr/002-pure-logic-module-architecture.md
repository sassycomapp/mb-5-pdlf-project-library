---
document: ADR-002 — Pure Logic Module Architecture
doc-id: mb5pdlf-0005
state: Live
date-created: 2026-06-30
---

# ADR-002 — Pure Logic Module Architecture

**Status:** Approved
**Date:** 2026-06-30
**Authority:** PDLF Stage 8 (Architecture & Standards)
**Project:** mb5pdlf (Daily Intentions Tracker)

## Context

The app's critical business logic — date handling, lock detection, state determination, record validation — must be testable. Anvil server modules that import `anvil.server` or `app_tables` cannot be unit-tested without an Anvil runtime, which makes automated testing impractical for a small project.

mb-3-cs uses a "pure logic module" pattern (per `docs/architecture.md`, advisory via ADR-001): modules with no Anvil imports that contain side-effect-free business logic, unit-testable with standard Python tools. mb-3-cs states: "This structure is not a preference. It is what makes the testing strategy work."

## Decision

mb5pdlf adopts the pure logic module pattern. Two server modules are pure (no Anvil imports):

- `date_logic.py` — `get_client_today()`, `is_past_date(date, today)`, `should_lock(record, today)`
- `record_ops.py` — `determine_state(record)`, `validate_intentions(i1, i2, i3)`, `validate_review(d1, d2, d3, reflection)`

One server module is impure (has Anvil imports, acts as the shell):

- `server_calls.py` — `@anvil.server.callable` functions that validate input via pure logic, interact with `app_tables`, and return response envelopes.

## Consequences

- **Positive:** Business logic is unit-testable without Anvil. Tests run in standard Python. The PDLF testing strategy (stage 15) has a real testable core.
- **Negative:** Slight module overhead — 3 server modules instead of 1. For a small app, this is acceptable.
- **Adoption note:** Pattern adopted from mb-3-cs `docs/architecture.md` (advisory per ADR-001). Reason it fits: mb5pdlf's logic is small but critical (lock detection, state determination) and must be verifiable.

## Related

- mb-3-cs `docs/architecture.md` — pure logic module pattern (advisory)
- ADR-001 — cross-project Anvil knowledge reuse
- ADR-003 — lock enforcement strategy (depends on this pattern)
