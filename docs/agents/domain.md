# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

## Two-repo architecture

This application spans two repos:

- **`mb5pdlf-project-library`** (this repo) — planning, documentation, ADRs, wireframes, design artefacts. PDLF test project.
- **`mb5pdlf`** — live application code (Python/Anvil). Daily Intentions Tracker app (Anvil slug: `mb5pdlf`).

This project exists specifically to test the PDLF development framework end-to-end. The app (Daily Intentions Tracker) is deliberately small — test honesty about the PDLF process matters more than shipping a polished product.

Both repos apply to the same application. When a skill needs implementation context, read from `mb5pdlf`. When it needs architectural decisions or design context, read from this repo.

## Before exploring, read these

- **`CONTEXT.md`** at the repo root — domain glossary and key concepts (create lazily via `/domain-modeling` when needed).
- **`adr/`** at the repo root — Architecture Decision Records.

If any of these files don't exist, **proceed silently**. The `/domain-modeling` skill (reached via `/grill-with-docs` and `/improve-codebase-architecture`) creates them lazily when terms or decisions actually get resolved.

## File structure

Single-context repo:

```
/
├── CONTEXT.md                ← domain glossary (created lazily)
├── adr/                      ← Architecture Decision Records
├── docs/
│   └── agents/               ← Agent configuration
├── pre-project/              ← Developer's first-thoughts (PDLF input)
├── pdlf/                     ← PDLF orchestrator artifacts
├── output-gstack/            ← GStack skill outputs
├── output-matt-skills/       ← Matt Pocock skill outputs
├── wireframes/               ← HTML wireframes
├── screens/                  ← Screen HTML mockups
└── wip/                      ← Work in progress
```

## Use the glossary's vocabulary

When your output names a domain concept, use the term as defined in `CONTEXT.md`.

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding.
