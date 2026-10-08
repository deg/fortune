# Agent Instructions

This project uses **bd** (beads) for issue tracking. Run `bd prime` for the full workflow.

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
```

Issues live in an embedded Dolt database under `.beads/`, not in git-tracked JSONL.
Its Dolt remote is this repo's GitHub origin. `bd sync` and `bd dolt push` publish issue
data there, so they are pushes, not local bookkeeping.

## Ending a Session

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - `make test`
3. **Update issue status** - Close finished work, update in-progress items
4. **Commit** - With the user's approval
5. **Hand off** - Provide context for next session

**Do not push.** Never run `git push`, `bd sync` or `bd dolt push` unless the user asks.
Publishing to GitHub is the user's decision.
