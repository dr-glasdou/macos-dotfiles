---
description: Command to generate a PR description using code analysis
agent: build
model: opencode/deepseek-v4-flash-free
---

Generate a PR description from code analysis.
Optional context: `$ARGUMENTS` (free text, and/or a target branch like `base:staging` to override the base).

# Execution
1. Determine the base branch: if `$ARGUMENTS` specifies one (e.g. `base:<branch>`), use that. Otherwise auto-detect via `git remote show origin`, else fall back to `develop|dev`, then `main`. Verify the branch exists (`git rev-parse --verify <base>`) before using it.
2. Get changed files: `git diff --stat $(git merge-base HEAD <base>)..HEAD`.
3. Run `caveman-review` on `git diff $(git merge-base HEAD <base>)..HEAD` for key logic changes and risks.
4. Infer a concise title from `git log --oneline $(git merge-base HEAD <base>)..HEAD` and `$ARGUMENTS`.
5. Create the PR:

```sh
gh pr create --base <base> --title "<inferred title>" --body "$(cat <<'EOF'
## Summary
[Intent of these changes in 2–3 sentences]

## Key Changes
[caveman-review bullets — logic changes, decisions, refactors]

## Risks & Notes
[Side effects, breaking changes, areas needing review — from caveman-review]

## Files Changed
[git diff --stat output]
EOF
)"
```

# Notes
- Use `$ARGUMENTS` to sharpen the title and summary when provided.
- If `.github/pull_request_template.md` exists, use its structure instead.
- No draft PR unless the user asks.
