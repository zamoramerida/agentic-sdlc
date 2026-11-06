# Agentic SDLC

A practical, evidence-driven operating model for building software with AI agents without surrendering engineering judgment. It is designed to make work understandable, testable, reviewable, and safe—not merely fast.

## The standard

Every meaningful change must have a clear problem, an agreed outcome, a bounded plan, implementation evidence, and an accountable human review. Agents may accelerate analysis and implementation; they do not own product decisions, waive quality gates, or approve their own work.

**Do not merge work because it looks plausible.** Verify it against explicit acceptance criteria and relevant tests. If evidence is missing, say so and keep the work unmerged.

## Start here

- [`AGENTS.md`](AGENTS.md): instructions for coding agents working in this repository.
- [`CONTRIBUTING.md`](CONTRIBUTING.md): contributor workflow and quality bar.
- [`docs/agentic-sdlc.md`](docs/agentic-sdlc.md): the end-to-end change lifecycle.
- [Issue templates](.github/ISSUE_TEMPLATE): capture problems and outcomes before implementation.
- [Pull request template](.github/PULL_REQUEST_TEMPLATE.md): report scope, evidence, and remaining risks.
- [`docs/templates/implementation-plan.md`](docs/templates/implementation-plan.md): plan non-trivial work before coding.
- [`docs/decision-records/README.md`](docs/decision-records/README.md): record durable technical decisions.

## Principles

1. **Problem before solution:** establish user need, context, and success criteria before asking an agent to code.
2. **Plan before broad edits:** break work into bounded steps, identify affected surfaces and risks, and agree on behavior-changing decisions.
3. **Small, reviewable changes:** prefer incremental diffs over large speculative rewrites.
4. **Evidence over confidence:** run relevant checks and inspect the resulting diff; never claim checks passed if they were not run.
5. **Human accountability:** a qualified human reviews requirements, security-sensitive changes, and the final diff before merge.
6. **Least privilege and explicit control:** do not expose secrets, grant unnecessary access, or let agents make irreversible production changes without authorized controls.
7. **Learn from outcomes:** record material decisions and use defects or near misses to improve the workflow.

## Scope

This repository provides process guidance and reusable templates. It is not a substitute for repository-specific architecture, testing, security policies, regulatory controls, or human judgment. Adapt the guidance to the risk and context of each project; do not lower required safeguards for convenience.
