# CLAUDE.md — fortune

CLI fortune tool. Python, **uv** (`uv.lock`, `pyproject.toml`).

**Read `AGENTS.md` in this directory first** — it carries the beads (`bd`) issue-tracking
workflow and session-completion rules for this project.

## Make targets (verified against the Makefile)
```
make install   make run      make build     make clean
make test      # = test-python + test-shell
make test-cov  make data     make setup     make notify    make clipboard
```

Also installable directly: `uv tool install --editable .`, then run `fortune`.
