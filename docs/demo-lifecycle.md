# Agentic SDLC Demo: End-to-End Lifecycle Guide

This document describes the complete, traceable flow from a GitHub issue through agent-assisted implementation, CI validation, human review, merge, and automated deployment to GitHub Pages.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites & Setup](#prerequisites--setup)
3. [End-to-End Runbook](#end-to-end-runbook)
4. [Traceability](#traceability)
5. [Permissions & Access Control](#permissions--access-control)
6. [Verification Checklist](#verification-checklist)
7. [Troubleshooting & Recovery](#troubleshooting--recovery)
8. [Rollback Procedures](#rollback-procedures)

## Overview

The agentic SDLC demo demonstrates a disciplined workflow where:

- **Issues** define scoped problems with acceptance criteria
- **Agents** understand, plan, and implement changes
- **CI** validates code automatically with required checks
- **Humans** review and approve; they control the merge gate
- **Automation** deploys after human-approved merge to `main`
- **Traceability** is preserved from issue → PR → commit → deployment

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. Create Issue                                                 │
│    ├─ Problem statement                                         │
│    ├─ Acceptance criteria                                       │
│    └─ Constraints                                               │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────────┐
│ 2. Agent Implements (Copilot)                                   │
│    ├─ Understands issue & acceptance criteria                   │
│    ├─ Plans implementation                                      │
│    ├─ Writes code & tests                                       │
│    └─ Contributor opens linked PR                               │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────────┐
│ 3. CI Checks Run (GitHub Actions)                               │
│    ├─ Build demo site                                           │
│    ├─ Validate HTML/CSS/JS                                      │
│    ├─ Accessibility checks                                      │
│    ├─ Link validation                                           │
│    └─ Mark as required checks                                   │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                    Must Pass ✓
                           │
                           ↓
┌─────────────────────────────────────────────────────────────────┐
│ 4. Human Review (Maintainer)                                    │
│    ├─ Read issue & acceptance criteria                          │
│    ├─ Inspect diff and changes                                  │
│    ├─ Verify CI checks passed                                   │
│    ├─ Approve or request changes                                │
│    └─ Only humans can approve                                   │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                    Must Approve ✓
                           │
                           ↓
┌─────────────────────────────────────────────────────────────────┐
│ 5. Authorized Merge to main (Maintainer)                        │
│    ├─ Merge PR (human action)                                   │
│    ├─ Commit lands on main                                      │
│    └─ Issue auto-closes (if "Closes #N")                        │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────────┐
│ 6. Deploy to GitHub Pages (Automation)                          │
│    ├─ Workflow triggers on main push                            │
│    ├─ Builds static site                                        │
│    ├─ Deploys to GitHub Pages                                   │
│    └─ Public URL updated                                        │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ↓
┌─────────────────────────────────────────────────────────────────┐
│ 7. Verify Deployment (Manual)                                   │
│    ├─ Check Actions tab shows ✅                                │
│    ├─ Visit site URL                                            │
│    └─ Confirm changes are live                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Prerequisites & Setup

### Required Access

- **Issue creation:** Anyone with repo write access
- **PR reviews:** Maintainers (with `write` permission)
- **Merge/deploy:** Maintainers (with `admin` permission)
- **Copilot agent:** GitHub Copilot subscription or CLI access

### Required Settings

#### GitHub Pages Configuration

1. Go to repository **Settings → Pages**
2. Set **Source** to `GitHub Actions`
3. Leave **Branch** as default (automatically uses Actions deployment)
4. **Custom domain** is optional

Pages will deploy artifacts uploaded by `actions/deploy-pages@v4` in the `deploy.yml` workflow.

#### Production Deployment Environment (Required)

The deploy job uses the `github-pages` environment. A repository administrator must restrict this environment to the `main` branch so it independently blocks deployments from feature branches:

1. Go to repository **Settings → Environments** and create or open `github-pages`
2. Under **Deployment branches and tags**, select **Selected branches and tags**
3. Allow only the `main` branch

The workflow keeps manual dispatch for recovery, but both build and deploy jobs run only for `refs/heads/main`. For recovery, select `main` when manually running the workflow. The environment restriction is a separate safeguard and must be verified by a repository administrator; this documentation does not imply it is configured.

#### Branch Protection (Required)

The issue-to-PR demo requires a human review and passing CI before a change can merge. Workflows report results, but do not enforce a merge gate by themselves. A repository administrator must configure branch protection or an equivalent ruleset for `main` before using this runbook:

1. Go to repository **Settings → Branches**
2. Add rule for `main`
3. **Require pull request reviews before merging:** Enable
4. **Required approvals:** 1
5. **Require status checks to pass:**
   - `Build & Validate Demo Site`
   - `Accessibility Checks`
   - `Check Links`

Select the displayed check names above; `build-and-validate` is a workflow job ID, not the displayed status-check name. The repository settings must be inspected by an administrator to confirm this protection is active; the workflow files alone do not prove that it is configured.

#### Workflow Permissions

The workflows are configured with **least-privilege permissions**:

- **CI workflow (`ci.yml`):** `contents: read, pull-requests: read`
- **Deploy build job (`deploy.yml`):** `contents: read`
- **Deploy job (`deploy.yml`):** `pages: write, id-token: write`

No secrets or elevated permissions are used.

## End-to-End Runbook

### Step 1: Create an Issue

**Actor:** Anyone  
**Permissions:** Write to repository  

A well-scoped issue for the demo:

```markdown
### Problem
The agentic SDLC demo needs [specific feature].

### Desired outcome
[Clear description of what success looks like]

### Acceptance criteria
- [ ] [Specific, verifiable requirement]
- [ ] [Another requirement]
- [ ] [Another requirement]

### Constraints
[Scope boundaries, risks, dependencies]
```

**Example:** Issue #9 "Build a minimal static demo site for GitHub Pages"

**Evidence of completion:**
- Issue is created on GitHub
- Issue number is assigned (e.g., #9)
- Issue is visible in the Issues tab

### Step 2: Request Copilot to Implement

**Actor:** Contributor or maintainer  
**Permissions:** Copilot CLI access  

**Using Copilot CLI:**
```bash
cd /path/to/agentic-sdlc
copilot
```

Authenticate through the CLI if prompted, then enter a request such as:

```text
Implement issue #9: build a minimal static demo site for GitHub Pages.
Follow the repository instructions, verify the acceptance criteria, and prepare
a pull request linked to the issue. Do not approve or merge the pull request.
```

**Or via GitHub.com:**
- Open issue #9 on github.com
- Look for Copilot or AI-assist button (if available)
- Request implementation

**What happens:**
1. Copilot reads the issue and acceptance criteria
2. Copilot inspects the repository structure and conventions
3. Copilot shows you a plan for the implementation
4. You approve or request changes to the plan
5. Copilot implements the changes
6. The contributor opens a pull request with the issue link; a GitHub-hosted coding agent may open it on the contributor's behalf

**Evidence of completion:**
- PR is opened on GitHub
- PR number is assigned (e.g., #12)
- PR description includes link to issue (e.g., "Closes #9" or "Relates to #9")
- PR is linked in the issue conversation
- Draft or ready status per user request

### Step 3: CI Checks Run Automatically

**Actor:** GitHub Actions (automatic)  
**Permissions:** Read contents, write checks  

When the PR is created, GitHub Actions automatically:

1. **Checks out the branch**
2. **Builds the demo site:**
   ```
   bash scripts/build-site.sh
   ```
3. **Validates output:**
   - ✅ `_site/index.html` exists
   - ✅ `_site/assets/css/styles.css` exists
   - ✅ `_site/assets/js/script.js` exists
4. **Validates structure:**
   - ✅ HTML tags are properly closed
   - ✅ CSS has expected content
   - ✅ JavaScript has expected content
5. **Checks accessibility:**
   - ✅ H1 heading present
   - ✅ Lang attribute on `<html>`
   - ⚠️  Image alt tags (warnings only)
6. **Validates links:**
   - ✅ Local files exist
   - ✅ Anchors are documented

**CI workflow file:** `.github/workflows/ci.yml`

**Evidence of completion:**
- PR shows all checks passed ✅
- Check names visible: "Build & Validate Demo Site", "Accessibility Checks", "Check Links"
- No red X marks
- Artifacts uploaded and available for download

**If checks fail:**
- Agent can commit fixes to the same branch
- CI reruns automatically
- Cycle repeats until checks pass

### Step 4: Human Review & Approval

**Actor:** Maintainer or authorized reviewer  
**Permissions:** `write` or `maintain` role  

The reviewer:

1. **Reads the issue:**
   - Understand the problem and acceptance criteria
   - Verify scope is bounded

2. **Inspects the PR:**
   - Click "Files changed" to see the diff
   - Verify changes are focused and maintainable
   - Check commit messages are clear
   - Verify no unrelated changes are included

3. **Verifies CI checks:**
   - All required checks show ✅
   - No failing checks
   - Artifacts are available

4. **Approves or requests changes:**
   ```
   ✅ "Looks good, thanks! This cleanly implements the issue."
   ```
   or
   ```
   💬 "Can you add accessibility testing to the CI?"
   ```

5. **Important:** Only authorized maintainers approve. Agents cannot approve their own work.

**PR status:**
- Approved PRs show green checkmark ✅
- Unapproved PRs show "Changes requested" or "Review required"
- Required reviews are enforced by the branch-protection rule configured above

**Evidence of completion:**
- PR shows "Approved" review
- All conversations resolved
- All required checks passing
- Ready to merge

### Step 5: Merge to main

**Actor:** Maintainer (authorized)  
**Permissions:** `admin` or `maintain` on repository  

The maintainer:

1. **Confirms all requirements:**
   - ✅ Acceptance criteria met
   - ✅ CI checks passing
   - ✅ Human approval present
   - ✅ No unresolved conversations

2. **Clicks "Merge pull request"**
   - GitHub auto-links issue if PR says "Closes #N"
   - Issue is auto-closed
   - Commit lands on `main`

3. **Verifies merge:**
   - PR status changes to "Merged"
   - Commit is visible in `main` branch history

**Evidence of completion:**
- PR labeled "Merged"
- Commit is on `main` branch
- Issue is closed (if "Closes #N" was in PR)
- Deployment workflow triggers automatically

### Step 6: Automated Deployment to GitHub Pages

**Actor:** GitHub Actions (automatic)  
**Permissions:** `pages: write`, `id-token: write`  

The deployment workflow:

1. **Triggers on push to `main` or manual dispatch**
   - Watches for changes to `demo/`, `scripts/build-site.sh`, or workflow itself
   - Both jobs are gated to `refs/heads/main`; manual recovery must select `main`

2. **Build job:**
   - Checks out `main`
   - Runs `bash scripts/build-site.sh`
   - Validates output exists and is correct
   - Uploads artifact to GitHub Pages

3. **Deploy job:**
   - Uses `actions/deploy-pages@v4`
   - Publishes artifact to GitHub Pages
   - Reports deployment URL

**Deployment workflow file:** `.github/workflows/deploy.yml`

**Evidence of completion:**
- Actions tab shows green ✅ for "Deploy Demo Site to GitHub Pages"
- Deployment job shows `page_url` in logs
- Public site URL is updated
- Site is live and accessible

**Example URL:**
```
https://zamoramerida.github.io/agentic-sdlc/
```

### Step 7: Manual Verification

**Actor:** Maintainer or anyone  
**Permissions:** Read repository, access to internet  

Verify the deployment:

1. **Check Actions tab:**
   - Go to Actions → "Deploy Demo Site to GitHub Pages"
   - Latest run shows ✅
   - Click to see deployment logs and URL

2. **Visit the site:**
   - Copy the `page_url` from deployment output
   - Open in browser
   - Verify the demo site is live
   - Check your changes are visible

3. **Confirm traceability:**
   - Note the commit SHA on `main`
   - Visit the Actions tab and confirm workflow ran for that commit
   - Verify the closed issue number

**Evidence of completion:**
- Public site is live and accessible
- Demo shows the implementation
- URL is documented and works
- Traceability chain is complete: Issue → PR → Commit → Deployment

## Traceability

Every step is traceable and verifiable:

### Issue → PR Link

**How:** PR description includes `Closes #9` or `Relates to #9`

**Verify:**
- Open PR
- Check "Linked issues" section
- See the original issue

### PR → Commit

**How:** Merge commits include PR number in message

**Verify:**
```bash
git log --oneline main
# Example: Merge pull request #12 from user/branch
```

### Commit → Deployment

**How:** GitHub Actions workflow logs show commit SHA

**Verify:**
- Go to Actions → Deployment workflow
- Click the latest run
- See commit SHA in logs
- See `page_url` output

### Full Chain

```
Issue #9 → PR #12 → Commit abc1234 → Deployed to Pages
```

## Permissions & Access Control

### Least Privilege

The workflows use minimal required permissions:

| Component | Permission | Reason |
|-----------|-----------|--------|
| CI workflow | `contents: read` | Read code to build |
| CI workflow | `pull-requests: read` | Read PR context |
| Deploy workflow | `contents: read` | Read code to build |
| Deploy workflow | `pages: write` | Publish to Pages |
| Deploy workflow | `id-token: write` | GitHub OIDC for auth |

**No secrets are used.** All authentication is GitHub-native.

### Human Approval Gate

- Agents can create PRs but cannot approve them
- Agents cannot merge their own PRs
- Only `write`/`maintain`/`admin` users can approve and merge
- Branch protection configured as described above enforces this

### Repository Settings

| Setting | Value | Reason |
|---------|-------|--------|
| Default branch | `main` | Release target |
| Branch protection | Required on `main` | Enforce review gate |
| Required reviews | 1 | Human approval |
| Status checks | Enabled | Enforce CI pass |
| Pages source | GitHub Actions | Deployment target |

## Verification Checklist

Before confirming the demo is working, verify:

### Issue & PR Linking
- [ ] Issue #9 exists with clear acceptance criteria
- [ ] PR #12 (or similar) was created
- [ ] PR description links to issue (search for "Closes #9" or "#9")
- [ ] PR appears in issue's "Linked pull requests" section

### CI Checks
- [ ] All checks passed on PR (green ✅)
- [ ] Check names visible: Build, Accessibility, Links
- [ ] Artifacts are available for download
- [ ] No failed checks

### Human Review
- [ ] PR has an approval review ✅
- [ ] Reviewer is authorized (maintainer role)
- [ ] No unresolved conversations
- [ ] Ready to merge

### Merge
- [ ] PR is merged to `main` (status "Merged")
- [ ] Issue is closed (if "Closes #N" in PR)
- [ ] Commit is visible on `main` branch

### Deployment
- [ ] Deployment workflow triggered (Actions tab)
- [ ] Build job completed successfully ✅
- [ ] Deploy job completed successfully ✅
- [ ] Deployment shows `page_url` output

### Public Site
- [ ] Site is live at `https://zamoramerida.github.io/agentic-sdlc/`
- [ ] Site content matches the implementation
- [ ] Demo is responsive (test on mobile)
- [ ] All links work (internal and external)

### Traceability
- [ ] Issue #9 → PR #12 (visible in issue)
- [ ] PR #12 → Commit abc1234 (in merge message)
- [ ] Commit → Deployment (in Actions logs)
- [ ] Full chain is documented

## Troubleshooting & Recovery

### CI Checks Failed

**Symptom:** PR shows red ✗ on one or more checks

**Diagnosis:**
1. Click the failed check
2. Read the error message
3. Determine the root cause

**Common issues:**
- Build script path wrong: update `scripts/build-site.sh`
- Missing file in demo: check `/demo/` directory
- HTML/CSS/JS syntax error: fix and re-run build locally

**Recovery:**
1. Fix the issue locally
2. Commit and push to the same branch
3. CI reruns automatically
4. Repeat until checks pass

### Human Review Stalled

**Symptom:** PR has no approval after several days

**Recovery:**
1. Comment on the PR to ping the reviewer
2. Check if there are unresolved comments (request changes)
3. Update PR or address feedback
4. Request review again

### Merge Conflict

**Symptom:** PR shows "This branch has conflicts"

**Cause:** Changes on `main` conflict with PR branch

**Recovery:**
1. Pull latest `main` locally
2. Rebase or merge `main` into your branch
3. Fix conflicts manually
4. Push updated branch
5. CI reruns automatically

### Deployment Workflow Didn't Trigger

**Symptom:** No deployment after merge, or deployment shows ✗

**Diagnosis:**
1. Check Actions tab for "Deploy Demo Site to GitHub Pages" workflow
2. Look for the most recent run
3. Check logs for error messages

**Common issues:**
- Pages not enabled in repository settings
- Workflow permissions not configured
- Artifact upload failed in build job

**Recovery:**
1. Verify GitHub Pages is enabled (Settings → Pages)
2. Check Pages source is set to "GitHub Actions"
3. Manually trigger workflow: Actions → Deploy → "Run workflow", selecting `main`
4. Check logs for detailed error

### Site Deployed But Content Looks Wrong

**Symptom:** Site is live but shows old content or broken layout

**Diagnosis:**
1. Do a hard refresh in browser (Cmd+Shift+R on Mac, Ctrl+Shift+R on Linux/Windows)
2. Check browser cache
3. Verify the commit on `main` includes your changes
4. Check the Actions logs to confirm the right commit was deployed

**Recovery:**
1. Clear browser cache
2. If changes aren't live, check the build logs in Actions
3. Trigger manual redeploy: Actions → Deploy → "Run workflow"
4. Wait a few minutes for Pages to update (5-10 min is normal)

## Rollback Procedures

### Rollback a Deployment

If the site is live but has an issue:

**Option 1: Revert the commit (clean rollback)**

```bash
git switch -c revert-demo-release main
git revert <commit-sha>
git push -u origin revert-demo-release
```

Open a pull request from the revert branch and require the same CI checks and human review before merging. GitHub Actions will rebuild and redeploy after that reviewed merge.

**Option 2: Revert directly on GitHub**

1. Go to the commit on `main`
2. Click "Revert" button
3. Follow the prompts to create a revert PR
4. Approve and merge the revert
5. Deployment workflow runs automatically

**Option 3: GitHub Pages rollback**

1. Go to repository Settings → Pages
2. Look at "Deployments" or "GitHub Pages" history
3. GitHub Pages keeps a history of deployments
4. You can request earlier versions (depending on retention)

### Rollback an Issue (Reopen)

If an issue was closed but needs more work:

1. Go to the closed issue
2. Click "Reopen issue"
3. Comment with the reason
4. Create a new PR with the additional work

### Rollback a Review (Request Changes)

If a merged PR had issues:

1. Open a new issue describing the problem
2. Reference the merged PR (e.g., "Found issue from #12")
3. Follow the normal workflow to fix it
4. Create a new PR with the fix

## Next Steps

This runbook is the source of truth for operating the demo. To ensure it stays current:

1. **Test the full flow regularly** – Run through all 7 steps monthly
2. **Update when things change** – If workflows, permissions, or URLs change, update this doc
3. **Document admin setup** – Include any non-obvious permissions or settings
4. **Gather feedback** – Ask maintainers and contributors if the flow is clear

---

**Questions?** See [`docs/agentic-sdlc.md`](./agentic-sdlc.md) for the full lifecycle philosophy, or [`docs/issue-to-pr-workflow.md`](./issue-to-pr-workflow.md) for the developer perspective.
