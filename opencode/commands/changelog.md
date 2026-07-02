---
description: Command to generate/edit a changelog for a project
agent: build
model: opencode/deepseek-v4-flash-free
variant: low
---

Generate/edit a project changelog.
Optional context: `$ARGUMENTS` (free text, and/or a version override like `version:X.Y.Z`).

# Execution
1. Determine the next version (X.Y.Z): use `$ARGUMENTS` if it specifies one, else check the latest tag (`git describe --tags --abbrev=0`) and infer a bump from staged changes. Ask if ambiguous.
2. Bump the project version to match X.Y.Z in the relevant manifest:
   - `package.json` → set `"version": "X.Y.Z"`.
   - `pubspec.yaml` (Flutter) → set `version: X.Y.Z+N`, always incrementing the build number `+N` by 1 or put only 1 if the first time.
   - `go.mod` → record `X.Y.Z` for tracking purposes only (e.g. a version comment); do not change the module path.
3. Use `.agents/instructions/changelog.instructions.md` if present; else fall back to Keep a Changelog format.
4. Get the diff since the last tag: `git diff $(git describe --tags --abbrev=0)..HEAD`.
5. Run `caveman-review` on that diff to identify notable changes.
6. Format under the heading `## [X.Y.Z] - YYYY-MM-DD` per the instructions file.
7. Save to `CHANGELOG.md` (or `changelog.md` if that casing already exists).

# Git Actions
1. `caveman-commit` to stage and commit with `chore(changelog): update changelog for vX.Y.Z`.
2. Annotated tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`.
3. Push: `git push origin HEAD --tags`.
