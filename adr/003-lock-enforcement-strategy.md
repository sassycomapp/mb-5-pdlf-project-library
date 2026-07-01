# ADR-003 — Lock Enforcement Strategy

**Status:** Approved
**Date:** 2026-06-30
**Authority:** PDLF Stage 8 (Architecture & Standards)
**Project:** mb5pdlf (Daily Intentions Tracker)

## Context

The concept (stage 4) specifies that records lock after client-side midnight. The implementation question: should locking be purely client-side, purely server-side, or hybrid?

- **Pure client-side:** exploitable (user modifies client clock). Self-defeating in a discipline app, but architecturally unsound.
- **Pure server-side:** requires knowing the user's timezone. Adds complexity (timezone picker, timezone storage) that violates the concept's "no settings" rule.
- **Hybrid:** client provides the date (handles timezone naturally via browser), server enforces the lock (authoritative once set).

## Decision

**Hybrid: client-side date detection + server-side lock enforcement.**

1. `get_client_today()` sends the browser's date to the server. This handles timezone correctly without a timezone picker.
2. `check_and_lock_past_days()` runs at app startup (called from `Form1`). It locks any record where `date < today` (comparing stored date against client-provided today). The server is the authority.
3. Once `locked == True`, `save_review()` rejects writes. The lock is irreversible.
4. The only attack vector is "set your clock back" — which is self-defeating in a discipline app. No additional defense needed.

## Consequences

- **Positive:** Timezone-correct without settings. Server-authoritative lock. No client trust for the lock state.
- **Negative:** `check_and_lock_past_days()` runs on every app startup (minor performance cost — trivial for a single-user app with <365 records).
- **Concept alignment:** matches the concept's "client-side date comparison" (stage 4) while being architecturally sound. The concept said "client-side" meaning "use the client's timezone" — this decision honours that intent while adding server enforcement.

## Related

- ADR-002 — pure logic module architecture (`should_lock()` lives in `date_logic.py`)
- Stage 4 concept decision: lock after client-side midnight
- Stage 3 boundary exploration: timezone handling
