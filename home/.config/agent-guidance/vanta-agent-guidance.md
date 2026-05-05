# Vanta Personal Agent Guidance

These are personal supplemental notes for local Vanta work. System, workspace, and tracked repository instructions take precedence.

## Local Workflow Notes

- Use this file for personal workflow reminders, preferred verification commands, and shortcuts that are safe to keep in dotfiles.
- Keep repository-specific commands aligned with the tracked Vanta `AGENTS.md`.
- Do not add secrets, tokens, credentials, private URLs, customer data, or machine-private environment values.

## Commit Discipline

- Red, green, and refactor are separate commit boundaries.
- Do not combine red/green/refactor into one task-plan item.
- Plan files must label each commit boundary explicitly, for example:
  - `2a. static imports - red`
  - `2b. static imports - green`
  - `2c. static imports - refactor`
- Stop after each boundary for review unless the user explicitly asks to continue.
- Docs-only or analysis-only work may use a single commit boundary when no red/green/refactor loop applies.

## Placeholders

- Add preferred local setup reminders here.
- Add personal verification shortcuts here.
- Add reminders about recurring repo conventions here.
