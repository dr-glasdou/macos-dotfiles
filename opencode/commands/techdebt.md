---
description: Generate/edit a technical debt report to track and prevent debt
agent: build
model: opencode/deepseek-v4-flash-free
---
Generate/edit a technical debt report.
Optional context: `$ARGUMENTS` (e.g. `scope:src/api`, `severity:high`).
# Inspect
Run before planning: `git status --short`, `git grep -nE "TODO|FIXME|HACK|XXX|@deprecated"`, and stack-appropriate checks — `npm outdated`/`npm audit`, `flutter pub outdated`, `go list -m -u all`, `cargo outdated`.
# Safety
- Scope to `$ARGUMENTS` paths/severity if given, else whole repo respecting `.gitignore`.
- Read-only analysis — never modify source, never run fixes or upgrades.
- Never echo secrets surfaced during the scan.
# Collect
- **Markers**: `TODO`, `FIXME`, `HACK`, `XXX`, `@deprecated`.
- **Dependencies**: outdated/vulnerable/unpinned packages for the detected stack.
- **Tests**: missing coverage, skipped/`.only` tests, untested modules.
- **Complexity**: oversized files/functions, deep nesting, duplication hotspots.
- **Risk**: missing error handling, `any`/unsafe casts, dead code.
- Run `caveman-review` on the current diff or scoped files for additional issues.
- Use `.agents/instructions/techdebt.instructions.md` if present for formatting.
# Grade
Per item record: location, category, severity (High/Med/Low), impact, suggested fix.
# Plan
Show counts by severity and the top items. Proceed if unambiguous; ask only on real uncertainty.
# Write
Save/update `docs/TECH_DEBT.md`: Summary (counts by severity), a table grouped by category, then a prioritized Action Plan (quick wins vs. larger refactors). If the file exists, move resolved items to a **Resolved** section, refresh open items, never duplicate entries.
# Git Actions
`caveman-commit` to stage and commit with `docs: update tech debt report`.
# Summary
List the file written and counts by severity.
