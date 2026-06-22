---
name: write-pr-description
description: Generates a clear, structured pull request description from the current git diff and branch context.
---

# Write PR Description

## When to use

When a user asks you to write, generate, or draft a PR description, pull request summary, or changelog entry.

## Steps

1. Run `git log main..HEAD --oneline` to list commits on the branch.
2. Run `git diff main...HEAD --stat` to get a summary of changed files.
3. Run `git diff main...HEAD` to read the actual changes. For large diffs, focus on the most significant files.
4. Identify the type of change:

- **feat** — new capability added
- **fix** — bug corrected
- **refactor** — code restructured without behavior change
- **chore** — config, deps, or tooling
- **docs** — documentation only

## Output format

## Use this exact structure:

## Summary

- <bullet 1: the main thing this PR does>
- <bullet 2: secondary change if any>
- <bullet 3: optional — notable removal or deprecation>

## Why

<One or two sentences on the motivation. What problem does this solve? What was wrong before?>

## What changed

| File            | Change            |
| --------------- | ----------------- |
| path/to/file.ts | short description |
| ...             | ...               |

## Test plan

- [ ] <How to verify the main change works>
- [ ] <Edge case to check>

---

## Rules

- Never pad the summary with vague phrases like "various improvements" or "minor fixes"
- If the diff is only config or lockfile changes, say so explicitly
- Keep the Why section honest — if it's unclear from the diff, say "Motivation unclear from diff alone"
- Do not include the word "straightforward" or "simply"
