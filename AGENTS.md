# Agent Instructions for lsimons-$project

> This file (`AGENTS.md`) is the canonical agent configuration. `CLAUDE.md` is a symlink to this file.

<!-- Replace $project with your project name and update this description -->
Brief project description.

## Quick Reference

<!-- Update these commands for your project -->
- **Build**: `go build ./...`
- **Test**: `go test -race -cover ./...`
- **Lint**: `golangci-lint run`
- **Format**: `gofumpt -w .`
- **Tidy**: `go mod tidy`

One-time tool install:

```bash
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
go install mvdan.cc/gofumpt@latest
```

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
   go build ./...
   go test -race -cover ./...
   go vet ./...
   golangci-lint run
   go mod tidy -diff
   ```

2. **Push**:
   ```bash
   git pull --rebase && git push
   git status  # must show "up to date with origin"
   ```

Never stop before pushing. If push fails, resolve and retry.
