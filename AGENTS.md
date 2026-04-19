# Agent Instructions for lsimons-template-go

> This file (`AGENTS.md`) is the canonical agent configuration. `CLAUDE.md` is a symlink to this file.

> **If this repo still says "template" everywhere:** run
> `mise run init` once to rename the placeholder module to your
> project name. See `scripts/init.py` for details.

Brief project description.

## Quick Reference

<!-- Update these commands for your project -->
- **One-time setup**: `mise install` (installs Go, golangci-lint, gofumpt)
- **Build**: `mise run build` (or `go build ./...`)
- **Test**: `mise run test` (or `go test -race -cover ./...`)
- **Lint**: `mise run lint` (runs golangci-lint + gofmt check + go vet + tidy check)
- **Format**: `mise run format` (or `gofumpt -w .`)
- **Full CI gate**: `mise run ci`

## Structure

<!-- Document your project structure here. Minimal default:
- main.go at repo root
- internal/<feature>/ for private packages (feature-oriented, not layer-oriented)
- Add cmd/<binary>/ only when you have more than one binary
-->

## Guidelines

**Code quality:**
- `go vet ./...` and `golangci-lint run` must report zero issues
- Code must be `gofumpt`-formatted and `goimports`-clean
- Tests for all functionality; prefer the stdlib `testing` package
- Use `t.Context()`, `t.Setenv`, `t.Chdir`, and `testing/synctest` where they fit
- `go mod tidy -diff` must be clean before committing

## Commit Message Convention

Follow [Conventional Commits](https://conventionalcommits.org/):

**Format:** `type(scope): description`

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `build`, `ci`, `perf`, `revert`, `improvement`, `chore`

## Session Completion

Work is NOT complete until `git push` succeeds.

1. **Quality gates** (if code changed):
   ```bash
   mise run ci
   ```

2. **Push**:
   ```bash
   git pull --rebase && git push
   git status  # must show "up to date with origin"
   ```

Never stop before pushing. If push fails, resolve and retry.
