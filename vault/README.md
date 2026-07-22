# vault/

This is the project's decision record — the *why* behind the code, captured as we build. It is public on purpose: Tolvi tools are built with Tolvi, in the open. Bastion, in particular, reads this vault to interrogate a plan — so keeping it current is the point of the tool.

## What lives here

Engineering **decisions** (ADR-style): architecture, mechanism choices, contracts, rejected *technical* alternatives, edge cases, and patterns. Each is a Markdown file with frontmatter; `status: active` entries are current, `superseded` ones are history with a pointer to what replaced them.

## What does NOT live here

Business strategy, roadmap prioritization, competitive assessments, client or customer names, JIRA keys, revenue, PII, security-incident specifics, and day-to-day session logs. Those belong in a **private** vault. If a decision's *why* can't be told without one of them, sanitize it ("we require idempotency keys because an incident taught us" — not the incident's details) or keep the whole decision private.

## Contributing to the vault

When you change how this tool behaves, capture the reasoning and commit it with your code:

```shell
tolvi sync decision "Short imperative title"   # writes vault/decisions/YYYY-MM-DD-<slug>.md
```

See [CONTRIBUTING.md](../CONTRIBUTING.md). Use placeholders like `PROJ-142` for any ticket reference.
