# Decision records

Record decisions that are durable, consequential, and useful to future contributors—for example architecture boundaries, data ownership, security trade-offs, or a deliberate policy exception. Do not create a record for routine implementation details.

Use one Markdown file per decision, named `NNNN-short-title.md`, with the next available number. Keep records immutable after acceptance; supersede a decision with a new record rather than rewriting history.

## Template

```markdown
# <Decision title>

- Status: proposed | accepted | superseded | rejected
- Date: YYYY-MM-DD
- Decision owners: <people or team>

## Context
<Problem, constraints, and relevant evidence.>

## Decision
<What was decided and why.>

## Alternatives considered
<Meaningful alternatives and trade-offs.>

## Consequences
<Benefits, costs, risks, mitigations, and revisit triggers.>
```

A decision that changes user-facing behavior or risk posture requires review by an accountable human owner.
