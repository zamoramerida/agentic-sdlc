# Contributing

Contributions should improve the guidance or make it easier to apply, while preserving the repository's evidence-driven, human-accountable standard.

## Workflow

1. **Describe the problem.** For meaningful changes, open an issue or otherwise record the user need, intended outcome, and acceptance criteria. Small typo fixes may go directly to a pull request.
2. **Plan proportionally.** Before non-trivial edits, note affected guidance, alternatives or trade-offs, risks, and how the result will be checked. Ask maintainers about decisions that change policy or expected behavior.
3. **Make a focused change.** Keep the diff small and coherent. Update related links, examples, and templates so the guidance remains consistent.
4. **Verify.** Check Markdown rendering and links where practical, inspect every changed file, and confirm examples are safe and internally consistent. Report checks that could not be run.
5. **Request review.** Explain the motivation, summarize the changes, provide verification evidence, and disclose remaining risks or uncertainty. Do not merge your own change.

## Quality bar

- Guidance must be actionable, clear about responsibility, and proportionate to risk.
- Distinguish required safeguards from recommendations; avoid absolute claims that ignore context.
- Examples must not contain real secrets, private data, or unsafe instructions.
- Do not claim a tool, test, or policy is configured unless it has actually been configured and verified.
- Keep terminology consistent: agents assist; accountable people decide and approve.

## Change reporting

Pull requests should use the repository template. If a change alters a durable policy or technical direction, add or update a decision record using [`docs/decision-records/README.md`](docs/decision-records/README.md). If a check was not run, state why rather than implying success.
