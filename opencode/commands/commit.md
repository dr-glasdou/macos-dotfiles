---
description: Group changes into semantic commits and push
agent: build
model: opencode/deepseek-v4-flash-free
variant: low
---

Group all current changes into semantic commits and push the current branch.
Optional message context: `$ARGUMENTS`

# Inspect
Run before planning: `git status --short`, `git diff --stat`, `git diff`, `git stash list`, `git log --oneline -10`.

# Safety
- Sensitive files (`.env`, `*.key`, `*.pem`, tokens, secrets, credentials) → **stop and ask**.
- On `main`/`master` → confirm before pushing.
- Never use `--no-verify`, `--force`, `--amend`, or revert changes.

# Grouping
- Group files by intent: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `config`. Never mix intents in one commit.
- Add a scope when changes are clearly scoped to a module/dir/feature (`type(scope): message`); infer it from paths or `$ARGUMENTS`. Omit only when cross-cutting.
- Collapse multiple same-type/scope files that would each be trivial into one commit:
  - `git commit -m "type(scope): summary" -m "<body>"`
  - Body: one bullet per file (what + why). Only add a body for 2+ collapsed files.
- Match the style from `git log --oneline -10`. Use `$ARGUMENTS` only if it reflects the actual changes.

# Plan
Show each group, its message, and files. Proceed if unambiguous; ask only on real uncertainty.

# Execute
Per group: `git add <files>` then `git commit`. After all commits: `git push`.

# Summary
List each commit (hash + message) and the pushed branch.
