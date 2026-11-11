# GitHub Issue-to-PR Workflow

This document describes how to use GitHub Copilot to implement a well-scoped GitHub issue and contribute the result as a pull request to the agentic-sdlc repository.

## Overview

The workflow follows the disciplined agentic SDLC lifecycle, with clear boundaries between agent assistance and human review:

1. **Agent:** Understands the issue, plans implementation, writes code
2. **Automation:** Runs CI checks and validates the change
3. **Human:** Reviews the PR and makes the merge decision
4. **Automation:** Deploys after human-approved merge to `main`

Agents do not approve or merge their own work.

## Prerequisites

- GitHub Copilot access (via Copilot CLI or GitHub.com interface)
- Write access to a branch (typically via fork or feature branch)
- Familiarity with the repository's conventions (see [`docs/agentic-sdlc.md`](./agentic-sdlc.md))

## Starting an Issue

A good issue for agent implementation includes:

✓ **Clear problem statement** – What is the user problem?  
✓ **Desired outcome** – What does success look like?  
✓ **Acceptance criteria** – Specific, verifiable checkboxes  
✓ **Constraints** – Risk, scope boundaries, dependencies  

Example:
```
### Problem
The demo site needs...

### Desired outcome
A minimal static site deployed to GitHub Pages that...

### Acceptance criteria
- [ ] The site builds without errors
- [ ] The site is accessible on mobile and desktop
- [ ] The build script is documented

### Constraints
Keep the demo small. No backend, no secrets.
```

## Using Copilot to Implement

### Option 1: Copilot CLI (Recommended)

1. **Start from the repository:**
   ```bash
   gh copilot run "Implement issue #9: Build a minimal static demo site"
   ```

2. **Or open an issue in a session:**
   ```bash
   gh copilot issue open zamoramerida/agentic-sdlc --issue-number 9
   ```

3. **Agent workflow:**
   - Reads the issue and acceptance criteria
   - Inspects the codebase for patterns and conventions
   - Plans the implementation (shows you the plan)
   - Creates code and commits changes
   - Runs tests and validation
   - Opens a pull request linked to the issue

### Option 2: GitHub.com Web Interface

1. Open the issue on github.com
2. Use the "Copilot" or "AI" button in the issue (if available)
3. Request that Copilot implement the issue
4. Copilot will guide you through the workflow

## What the Agent Produces

The agent creates a pull request with:

✓ **Issue link** – PR description includes "Closes #N" or "Relates to #N"  
✓ **Focused changes** – Only the files needed for this issue  
✓ **Commit messages** – Clear, concise messages explaining each change  
✓ **Verification** – Tests, linting, build validation  
✓ **Evidence** – PR description documents what was checked  

Example PR body:
```markdown
Closes #9

## Implementation

Adds a minimal static demo site under `/demo/` showing the agentic SDLC lifecycle.

## Verification

✅ Build script tested and works: `bash scripts/build-site.sh`
✅ Site builds successfully to `_site/` directory
✅ HTML validates (no structural issues)
✅ CSS and JS load correctly
✅ Mobile and desktop responsive tested
✅ All acceptance criteria met

## Changes

- `/demo/index.html` – Main demo page (800 lines)
- `/demo/assets/css/styles.css` – Responsive styling
- `/demo/assets/js/script.js` – Navigation and animations
- `/scripts/build-site.sh` – Build script with verification
```

## Human Review

When the PR is ready:

1. **Reviewer checks:**
   - Does the change solve the stated problem?
   - Does it respect scope and constraints?
   - Are acceptance criteria met?
   - Is the code maintainable?
   - Do CI checks pass?

2. **Review options:**
   - ✅ **Approve and merge** – Change is ready to ship
   - 💬 **Request changes** – Agent makes revisions (cycles back to step 1)
   - ❌ **Reject** – Issue needs different approach

3. **Important:** Only authorized humans may approve or merge. Agents cannot merge their own work.

## Merge and Deployment

Once approved and merged to `main`:

1. **GitHub Actions triggers automatically:**
   - Build job compiles the site
   - Deploys to GitHub Pages
   - Reports deployment status

2. **Verify deployment:**
   - Check GitHub Actions workflow results
   - Visit the public site URL
   - Confirm the change is live

3. **Traceability:**
   - Issue is now closed
   - PR commit is on `main`
   - Deployment is visible in Actions tab
   - Rollback via GitHub Pages history if needed

## Repository Standards

When implementing an issue, the agent follows these standards:

### Code Style
- Follow patterns in existing code (check `/demo/`, `/docs/`)
- Use 2-space indentation for HTML/CSS/JavaScript
- Keep files focused and readable

### Documentation
- Update relevant docs (e.g., `README.md`, file headers)
- Add inline comments for complex logic
- Document build steps and output directories

### Testing
- Add tests for new behavior (if applicable)
- Test edge cases and negative scenarios
- Include verification in PR description

### Commits
- One logical change per commit
- Clear commit message: `what` and `why`, not just `what`
- Link to issue: "Closes #N" in description

### Security
- Never commit secrets or credentials
- Use least-privilege permissions in workflows
- Follow repository security guidance

## Troubleshooting

### "CI checks failed on my PR"
- Review the failed check in GitHub Actions
- Common issues: missing dependencies, build errors, linting failures
- Agent can commit a fix and push it; the new commit triggers CI again

### "My PR doesn't link to the issue"
- Edit the PR description to include "Closes #N"
- GitHub auto-links when you merge

### "I need to update the issue scope"
- Comment on the issue to clarify
- Agent reads new comments and can adjust the PR
- Request review again

### "I want to reject this PR"
- Request changes or close without merging
- Leave a comment explaining why
- Agent can open a revised PR

## Learning More

- **Full lifecycle:** See [`docs/agentic-sdlc.md`](./agentic-sdlc.md)
- **Repository conventions:** See [`CONTRIBUTING.md`](../CONTRIBUTING.md)
- **Demo experience:** Try the workflow on a real issue!

## Next Steps

1. Pick a well-scoped issue (marked `help-wanted` or `good-first-issue`)
2. Use Copilot CLI or web interface to start implementation
3. Review the PR and accept or request changes
4. Merge when satisfied
5. Verify the deployment on GitHub Pages
6. Enjoy a clean, traceable delivery! 🚀
