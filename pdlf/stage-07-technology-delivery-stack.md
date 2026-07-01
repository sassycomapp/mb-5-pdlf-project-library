# Stage 7 Output — Technology & Delivery Stack

**Project:** mb5pdlf (Daily Intentions Tracker)
**Stage:** 7 — Platform & Framework Selection
**Date:** 2026-06-30
**PDLF phase:** B (Define)

---

## Method

Muscle emphasis: channel muscle (welcoming existing channels — the Anvil platform and its dependencies are existing channels that make the project easier). The platform was already constrained by the distilled concept (stage 5) and the pre-project constraints. Stage 7 confirms, documents, and justifies — it does not select from alternatives. The selection was made at the concept level; this stage records it.

---

## 1. Execution environment

### Platform: Anvil.works

| Aspect | Value | Source |
|---|---|---|
| Platform | Anvil.works (server-side Python, client-side Python, web UI) | Pre-project hard constraint #1 |
| App name | mb5pdlf | Anvil app (user-created) |
| App slug | mb5pdlf | Anvil + GitHub |
| Server spec | `python310-minimal` (per anvil.yaml) | Anvil default |
| Client version | 3 (per anvil.yaml) | Anvil default |
| Deployment | Anvil hosted (via GitHub VC) | Pre-project constraint |

### Code repository

| Aspect | Value |
|---|---|
| Repo path | `/mnt/c/_project-mb5pdlf/mb5pdlf/` |
| GitHub remote | `https://github.com/sassycomapp/mb5pdlf.git` |
| anvil.yaml | Present — **NEVER WRITE TO IT** (AGENTS.md hard rule) |
| Current state | Scaffolded by Anvil (Form1, theme, server_code) — no app logic yet |

---

## 2. Foundational stack (dependencies)

### Installed dependencies (from anvil.yaml — read-only, do not modify)

| Dependency | ID | Version | Purpose |
|---|---|---|---|
| Material 3 Theme | `4UK6WHQ6UX7AKELK` | v1.2.6 | UI component library — all UI built with M3 native components |

### Dependencies NOT installed (deliberately)

| Dependency | Why not | Source |
|---|---|---|
| Anvil Routing (`3PIDO5P3H4VPEMPL`) | Not needed for v1 — startup module redirects to Today. Only 2 screens, no URL routing. | Stage 3 decision + PCD stage 6 |
| Anvil Extras | Never used — per mb-3-cs ADR-014 (advisory, adopted per ADR-001) | ADR-001 + mb-3-cs `adr/14-anvil-extras-exclusion.md` |

### Dependency decision

**No new dependencies needed for v1.** The M3 theme provides all required components. The app has two screens with a startup redirect — no routing module. No external Python packages needed (the app uses Anvil's built-in `app_tables` API and standard Python).

---

## 3. UI framework

### Material Design 3 (M3)

| Aspect | Value | Source |
|---|---|---|
| Theme dependency | `4UK6WHQ6UX7AKELK` (M3 Theme, v1.2.6) | anvil.yaml |
| Component approach | M3 native components only — no custom components, no non-M3 | Stage 3 + ADR-001 (mb-3-cs `docs/ui-standards.md`, advisory) |
| CSS approach | CSS Overlay — minimal custom CSS for spacing/typography, no component overrides | Pre-project soft constraint + ADR-001 (mb-3-cs `docs/design-direction.md`, advisory) |
| Theme folder | `theme/` (exists — contains `theme.css`, `parameters.yaml`, `templates.yaml`, `assets/`) | Anvil scaffold |

### M3 components required for v1

| Component | M3 native? | Used in | Notes |
|---|---|---|---|
| `m3.TextArea` | Yes | Morning form (3×), evening reflection | Free-text input, notecard feel |
| `m3.Button` | Yes | Morning save, evening save | Filled variant, primary action |
| `m3.Switch` | Yes (leaning) | Evening done toggles (3×) | Stage 13 confirms: Switch vs Checkbox |
| `m3.Card` | Yes (leaning) | History entries | Stage 13 confirms: Card vs other container |
| `ColumnPanel` | Yes | Form layout | Standard Anvil layout |
| `RepeatingPanel` | Yes (leaning) | History list | Stage 13 confirms: RepeatingPanel vs DataGrid |
| `Label` | Yes | Read-only text display (intentions, dates, messages) | Standard |

All required components are M3 native. No partially-supported components (Chips, Snackbar, Bottom Sheet, Tabs, Date Picker) needed. This is the simplest possible M3 app.

---

## 4. Data layer

### Anvil Data Tables

| Aspect | Value | Source |
|---|---|---|
| Data layer | Anvil Data Tables (built-in, no external database) | Pre-project hard constraint + concept decision |
| Tables for v1 | 1 (`intentions`) | Concept decision (stage 4: three fixed = single table) |
| Table schema | 12 columns (date, intention_1/2/3, done_1/2/3, reflection, locked, user_id, created_at, updated_at) | Stage 5 distilled concept |
| Access pattern | `app_tables.intentions.get(date=today)` for current day; `app_tables.intentions.search()` ordered by date desc for history | PCD stage 6 |
| Row-level security | Not needed (single user, no auth) | Pre-project constraint |
| Migration | Manual (no migration tool) — schema must be right at stage 10 | ADR-001 advisory (mb-3-cs `docs/anvil-spec-table.md` section 4) |

---

## 5. Development tools

| Tool | Role | Source |
|---|---|---|
| OpenCode | Agent runtime — PDLF orchestrator + GStack/Matt Pocock skills | PDLF stage 7 resource list |
| GStack skills | Workflow (QA, review, ship) | PDLF stage 7 resource list |
| Matt Pocock skills | Discipline (TDD, domain-modeling) | PDLF stage 7 resource list |
| GBrain | Memory (search mb-3-cs advisory, store mb5pdlf artifacts) | ADR-001 + PDLF |
| Anvil Editor | Visual form designer (stages 13–14) | Anvil platform |
| GitHub | Version control (both repos) | Pre-project |
| Anvil AI | AI-assisted Anvil development (optional, stages 14–16) | PDLF stage 7 resource list |

---

## 6. Cross-project advisory applied (per ADR-001)

This is the second application of ADR-001 (first was at stage 3). The following mb-3-cs advisory knowledge informed this stage:

| mb-3-cs source | What was applied | Advisory status |
|---|---|---|
| `docs/anvil-spec-table.md` | Confirmed M3 theme dependency ID, Anvil Data Tables access patterns, no migration tool | Advisory — confirmed, not adopted as constraint |
| `docs/ui-standards.md` | Confirmed M3 native components list, CSS Overlay approach | Advisory — confirmed for mb5pdlf |
| `adr/14-anvil-extras-exclusion.md` | Confirmed Anvil Extras exclusion | Advisory — adopted (no extras for mb5pdlf) |
| `docs/design-direction.md` | CSS Overlay approach | Advisory — confirmed for stage 13 |

**All advisory, not canonical.** Each application is noted per ADR-001's cross-contamination discipline. No mb-3-cs decision was adopted as a constraint on mb5pdlf without explicit reasoning.

---

## 7. Stack summary

| Layer | Technology | Dependency | Version |
|---|---|---|---|
| Platform | Anvil.works | — | runtime v3, python310-minimal |
| UI framework | Material Design 3 | `4UK6WHQ6UX7AKELK` | v1.2.6 |
| Data layer | Anvil Data Tables | (built-in) | — |
| Routing | None (startup redirect) | — | — |
| External APIs | None | — | — |
| Auth | None (v1) | — | — |
| Version control | GitHub | — | — |
| Agent runtime | OpenCode | — | — |
| Workflow skills | GStack (59 skills) | — | — |
| Discipline skills | Matt Pocock (18 skills) | — | — |
| Memory | GBrain (PGlite) | — | — |

**The stack is minimal.** One platform, one UI dependency, one data layer, no external dependencies. This is the simplest possible Anvil app that does something useful.

---

## BFT checkpoint (Stage 7)

- **Bones:** The bones of this stage are the platform constraints from the distilled concept (stage 5) and the PCD (stage 6). The big bones: Anvil.works, M3 theme, Anvil Data Tables, GitHub, OpenCode/GStack/Matt Pocock/GBrain. The key-type bone is the M3 theme dependency — it's the only external dependency, and every UI component depends on it.
- **Muscle:** Channel muscle (welcomed) — the Anvil platform and its M3 dependency are existing channels that make the project possible without building infrastructure. Information muscle (mb-3-cs advisory specs confirmed the dependency IDs and component lists). No logic muscle (no selection from alternatives — the platform was pre-constrained). No habit muscle (this is not "we always use Anvil" — it's "the concept requires Anvil").
- **Nerves:** Analyzing network (classification of stack into layers: platform, UI, data, tools). Each layer is a bone from the concept, confirmed and documented. No achieving or exploring — this is documentation of an existing decision.
- **Fat:** The stack is minimal — 1 platform, 1 UI dependency, 1 data layer, no routing, no extras, no external APIs. No fat detected. The advisory table (section 6) is muscle (it records which ADR-001 sources were applied), not fat.
- **Skin:** 7-section stack document. Tree structure: environment → dependencies → UI → data → tools → advisory → summary. Clear table format for quick reference. This document is a reference for stages 8–16.
- **Health:** Good in itself? Yes — the stack is complete (no missing layer), minimal (no unnecessary dependency), and confirmed (M3 dependency is installed and verified in anvil.yaml). Good for this project? Yes — the simplicity matches the concept's tight scope. The only external dependency is M3, which is already installed.

---

*Stage 7 output. Next: Stage 8 (Architecture & Standards) — define architecture, design rules, constraints, conventions, and quality principles. Apply ADR-001 advisory for architecture patterns. Resolve 3 open questions (lock enforcement, pure logic modules, routing).*
