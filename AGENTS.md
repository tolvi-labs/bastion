# AGENTS.md

Guidance for coding agents working in this repo. Humans: see [`CONTRIBUTING.md`](./CONTRIBUTING.md).

## What this is

Bastion is a pre-code crucible, shipped as a Claude Code skill: `/tolvi-bastion <plan | ticket | feature description>`. It interrogates a plan against the vault before any code exists, hardens it, and deposits the rationale as decisions.

## Layout

- `skills/tolvi-bastion/` is the skill. `SKILL.md` is the whole product.
- `.claude-plugin/plugin.json` is the manifest.
- `install.sh` symlinks the skill into `~/.claude/skills/`.

## Conventions

- **It never writes code.** That is the point, not a limitation. A change that has Bastion produce an implementation has broken it.
- **Challenges are resolved by the owner, not defaulted.** The value is in forcing tacit reasoning into explicit form. An agent that answers its own challenges has produced nothing.
- **Decisions are deposited, not summarized.** Output lands in `vault/decisions/` in the Tolvi format, which `tolvi-labs/tolvi` defines normatively.

## What not to do

- Do not let the skill drift from the vault format. `spec/tolvi-format-v2.md` in the tolvi repo is normative; this repo consumes it.
