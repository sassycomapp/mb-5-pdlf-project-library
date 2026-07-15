# Issue tracker: Local markdown

Issues and specs for this repo live as markdown files under `.scratch/`. This is a PDLF test project — PDLF's `/to-tickets` step (`to-tickets` skill) uses this tracker.

## Conventions

- **Create an issue**: create a markdown file at `.scratch/<feature>/<issue-slug>.md`. Use YAML frontmatter for metadata (title, status, labels).
- **Read an issue**: read the markdown file directly.
- **List issues**: glob `.scratch/**/` for markdown files; filter by frontmatter fields.
- **Comment on an issue**: append to the markdown file under a `## Comments` section with a timestamp.
- **Apply / remove labels**: edit the `labels` field in the frontmatter.
- **Close**: set `status: closed` in the frontmatter.

## File template

```yaml
---
title: "Issue title"
status: open          # open | closed
labels: []            # see docs/agents/triage-labels.md
created: 2026-07-06
---

## Description

Issue description here.

## Comments

<!-- Append comments with timestamps -->
```

## When a skill says "publish to the issue tracker"

Create a markdown file under `.scratch/`.

## When a skill says "fetch the relevant ticket"

Read the corresponding markdown file from `.scratch/`.
