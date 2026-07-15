---
description: Generate onboarding docs to understand an existing project
agent: build
model: opencode/deepseek-v4-flash-free
---
Generate documentation that explains an existing project for someone joining it.
Optional context: `$ARGUMENTS` (e.g. `focus:auth`, `depth:deep`).
# Inspect
Run before planning: `git ls-files | head -50`, `ls -la`, `cat` each manifest found (`package.json`, `pubspec.yaml`, `go.mod`, `Cargo.toml`, `requirements.txt`), CI config (`.github/workflows/*`, `.gitlab-ci.yml`), and `.env.example` if present.
# Safety
- Never read or echo real secrets (`.env`, `*.key`, `*.pem`, credentials) → use `.env.example` only; if absent, list the var names, never values.
- Pull commands from actual scripts/CI — **never invent** install/run/test commands.
- Don't modify source; this command only reads and writes docs.
# Analyze
- **Stack**: language(s), framework(s), package manager, runtime — from manifests + lockfiles.
- **Layout**: top-level dirs, each one's responsibility, and entry points (`main`, `index`, `cmd/`, `lib/main.dart`).
- **Architecture**: layers/modules, their dependencies, external services (DB, APIs, queues), request/data flow, patterns in use.
- **Workflow**: real install / run / build / test / lint commands.
- **Conventions**: naming, folder patterns, env vars, and any `CONTRIBUTING`/`.agents/instructions` rules.
- Use `.agents/instructions/docs.instructions.md` if present for formatting.
# Plan
Show the detected stack and section outline. Proceed if unambiguous; ask only on real uncertainty.
# Write
Save to `docs/PROJECT_OVERVIEW.md`: Overview, Tech Stack, Architecture, Directory Map, Getting Started, Key Flows, Conventions, External Dependencies, Glossary, Open Questions. Put anything unclear under **Open Questions** instead of guessing.
# Git Actions
`caveman-commit` to stage and commit with `docs: add project overview`.
# Summary
List the file written and the count of Open Questions raised.
