---
description: Command to generate a project manual with context optimization
agent: build
model: opencode/deepseek-v4-flash-free
variant: low
---

Generate two project manuals from a full codebase analysis.
Optional context: `$ARGUMENTS` (free text to focus or scope the analysis to a specific service, module, or concern).

# Pre-Analysis
- For any source/doc file larger than 20KB, use `caveman-compress` for a high-density summary before reading, and analyze from those to avoid context drift.

# Deep-Dive Analysis
Before writing, analyze the **entire** codebase — completeness over speed. Read every file (source, config, scripts, assets, tests, CI/CD, Docker, infra); don't skip anything uncertain. Specifically:
- Source: modules, services, controllers, providers, routes, models, schemas, hooks, components, guards, interceptors, middleware, pipes, decorators, migrations, seeders, shared utils.
- Config: env files, build configs, dependency manifests, deployment descriptors.
- Map integrations, third-party libs, external services, data flows, API contracts, auth mechanisms, state management, and inter-module communication.
- Detect architectural patterns (Clean Architecture, BLoC, DDD, feature-first, barrel exports, DI).

Determine the project name from `package.json`, `pubspec.yaml`, `go.mod`, or the root folder name (in that order). Generate the manuals only after the full scan.

# Manual 1 — Technical Reference (developers)
For developers onboarding or returning. Sections:
1. Overview — purpose, tech stack (Flutter / NestJS / Golang / Angular 19+), repo structure
2. Architecture — diagram description, layer responsibilities, module boundaries, dependency direction
3. Project structure — annotated directory tree
4. Environment setup — prerequisites, env vars, dev commands, required secrets/service accounts
5. Core modules & services — per module: purpose, public API, dependencies, notable details
6. Data models & schemas — relationships, DTOs, migrations, validation
7. API contracts — endpoints: method, path, auth, request/response shape, error codes
8. State management — patterns, store structure, data lifecycle
9. Auth — flows, guards, token handling, roles, permissions
10. Inter-service communication — queues, events, WebSockets, shared libs, HTTP clients
11. Testing — unit/integration/e2e locations, how to run, mocking conventions
12. CI/CD & deployment — pipeline steps, env promotion, Dockerfiles, infra
13. Patterns & conventions — naming, folders, code style, project idioms
14. Gotchas — non-obvious decisions that would surprise a new dev

# Manual 2 — Directive Overview (leads & stakeholders)
For leads/PMs/stakeholders comfortable with technical terms but not reading code. Sections:
1. What this system does — plain-language product summary
2. Technology choices — what each tech is used for and why (if inferable)
3. System components — services, apps, databases, queues, integrations (one paragraph each)
4. Data flow — entry → processing → storage → response
5. Key workflows — the 3–5 most important end-to-end flows
6. Security & access control — who can do what, high-level auth, compliance notes
7. Scalability & reliability — scaling, retries, error handling, availability
8. Dependencies & third-party services
9. Operational notes — health signals, what breaks first under load, known limits
10. Glossary — domain terms and project-specific names

# Output Rules
- Output path: `/docs` if it exists, else project root.
- Write two self-contained Markdown files (no cross-references):
  - `[projectName]-manual-technical.md` — English
  - `[projectName]-manual-directives.md` — Spanish (formal but approachable; `usted` preferred)
- In the directives file, keep technical terms, proper nouns, library names, and code references in English; no raw code (use pseudocode/plain descriptions).
- Use headers, tables, and code blocks where they aid clarity.
- Don't fabricate — mark undeterminable details as `[not found in codebase]`.
- Aim for exhaustive coverage — these go to NotebookLM for AI-assisted consultation.

# Mermaid Diagrams
Use fenced `mermaid` blocks where they add clarity. Never diagram unconfirmed relationships. Add a one-sentence caption below each. Split diagrams over ~20 nodes. Keep labels short.
- Manual 1: use freely. Manual 2: 1–2 high-level diagrams max.
- Types: `flowchart TD` (lifecycles, auth, pipelines), `erDiagram` (entities/relationships), `sequenceDiagram` (inter-service, API chains, handshakes), `classDiagram` (module deps, DI, domain hierarchy), `graph LR` (system architecture).
