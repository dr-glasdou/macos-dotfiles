---
description: Command to generate a list of tasks based on the git commit history
agent: build
model: opencode/deepseek-v4-flash-free
---

Summarize the current user's recent commits into a task list.
Optional context: `$ARGUMENTS` (a date or range to override the default week).

# Execution
1. Get the current user: `git config user.name` and `git config user.email`.
2. Date range: use `$ARGUMENTS` if it specifies one; else default to the current week (Monday 00:00 → today 23:59).
3. Fetch commits: `git log --all --oneline --author="<email>" --after="<start>" --before="<end>"`.
4. Run `caveman-review` on the list to group related commits and drop noise (merge commits, version bumps, typo fixes).
5. Summarize each meaningful group into one concise task.

# Output Rules
- Format: unordered Markdown list only — no headers, no preamble.
- Language: Spanish. Tense: infinitive ("Crear un endpoint...", not "Crea..." or "Creó...").
- Granularity: one task per logical change, not per commit.
- Omit noise (merge commits, changelog updates, dependency bumps) unless they're the only changes.

# Examples
- Crear un endpoint para la creación de usuarios.
- Agregar middleware de autenticación.
- Corregir validación en el formulario de registro.
- Migrar base de datos para soporte de múltiples roles.
