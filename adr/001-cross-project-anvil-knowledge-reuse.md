---
title: "001-cross-project-anvil-knowledge-reuse"
document: ADR-001 — Cross-Project Anvil Knowledge Reuse
doc-id: "mb-7e2501b7"
updated: "2026-10-06"
state: Live
date-created: 2026-06-30
---

# ADR-001 — Cross-Project Anvil Knowledge Reuse

**Status:** Approved
**Date:** 2026-06-30
**Authority:** User architectural decision (2026-06-30)
**Project:** mb5pdlf (Daily Intentions Tracker)

## Context

The mb5pdlf project is an Anvil.works application using Material Design 3. The mb-3-cs project (`C:\mybizz\project-library`) contains extensive proprietary knowledge about Anvil development practices, Material 3 theming, component specifications, coding standards, and architectural constraints — all acquired through months of active development.

mb5pdlf is a test project on the same platform (Anvil + MD3). Re-deriving this knowledge from scratch would waste time and produce inconsistent results. The knowledge already exists and is directly applicable.

## Decision

mb5pdlf will reference and apply Anvil proprietary knowledge from mb-3-cs's `docs/` and `adr/` folders at the appropriate PDLF stages.

### Specific sources to research and use

**At Stage 8 (Architecture & Standards):**
- `docs/anvil-spec-table.md` — Anvil specification and methods reference (navigation, components, data binding, data tables, packages, startup, coding standards)
- `docs/architecture.md` — architecture patterns (pure logic modules, client-server boundary)
- `docs/coding-standards.md` — coding standards for Anvil Python
- `adr/34-anvil-platform-constraints.md` — Anvil platform constraints and design boundaries
- `adr/14-anvil-extras-exclusion.md` — Anvil Extras exclusion (never used)

**At Stage 10 (Data Design):**
- `docs/anvil-spec-table.md` section 4 (Data Tables) — Anvil Data Tables patterns
- `docs/authoritative-schema.md` — schema design patterns

**At Stage 13 (UX/UI Design):**
- `docs/ui-standards.md` — Material Design 3 standards, M3 component list, MUI aesthetic overlay
- `docs/DESIGN.md` — design system (palette, typography, spacing, motion)
- `docs/m3_component_mapping.md` — M3 component mapping
- `docs/design-direction.md` — design direction and CSS overlay approach
- `adr/15-material-3-theme-component-scope.md` — M3 theme component scope
- `adr/37-ui-customization-approach.md` — UI customization approach
- `adr/27-design-rules.md` — design rules

**At Stage 14 (Frontend Assembly):**
- `docs/internal-standards-anvil-wireframe-conversion.md` — wireframe-to-Anvil conversion standards

### Cross-contamination discipline

Per the PDLF SKILL.md section 8.4 and the mb5pdlf AGENTS.md:

1. All mb-3-cs knowledge is **advisory, not canonical** for mb5pdlf.
2. mb-3-cs ADRs describe decisions made for a CRM application. They are inputs to mb5pdlf's decisions, not constraints on mb5pdlf.
3. mb5pdlf may adopt mb-3-cs patterns where they fit, but must not inherit mb-3-cs's scope (multi-tenant CRM) into a single-user tracker.
4. The M3 theme dependency (`4UK6WHQ6UX7AKELK`) is shared — both projects use the same Anvil M3 theme. This is a platform fact, not a project-specific decision.
5. Where mb5pdlf adopts an mb-3-cs pattern, the adoption must be explicitly noted in the mb5pdlf devlog: "Pattern adopted from mb-3-cs [source] — reason: [why it fits]."

## Consequences

- **Positive:** mb5pdlf benefits from months of Anvil platform knowledge without re-deriving it. UI consistency with mb-3-cs's Material 3 patterns. Faster stage 8/10/13/14 execution.
- **Negative:** Risk of over-applying CRM patterns to a simple tracker. Must actively resist importing mb-3-cs's complexity (multi-tenancy, RBAC, observability) into a single-user app.
- **Mitigation:** The cross-contamination discipline (section 8.4) requires explicit adoption notes and human confirmation for any cross-project decision applied as a constraint.

## Related

- mb-3-cs `docs/ui-standards.md` — M3 standards
- mb-3-cs `docs/anvil-spec-table.md` — Anvil specification
- mb-3-cs `adr/34-anvil-platform-constraints.md` — platform constraints
- PDLF SKILL.md section 8.4 — GBrain cross-contamination discipline
- mb5pdlf AGENTS.md section 3 — GBrain cross-contamination discipline
