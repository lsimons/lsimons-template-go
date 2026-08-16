# Agent Instructions for lsimons-template-go

> This file (`AGENTS.md`) is the canonical agent configuration. `CLAUDE.md` is a symlink to this file.

> **If this repo still says "template" everywhere:** run
> `mise run init` once to rename the placeholder module to your
> project name. See `scripts/init.py` for details.

Project template for Go CLI tools with standardized tooling.
See [README.md](README.md) for the user-facing description.

## Quick Reference

Every repo task lives in `.mise.toml`; `mise tasks` lists them.

| Task                 | What it does                                                     |
| -------------------- | ---------------------------------------------------------------- |
| `mise install`       | Install the pinned toolchain                                      |
| `mise run init`      | Rename the `template` placeholder to the project name             |
| `mise run install`   | `go mod download`; may write go.sum                               |
| `mise run install-frozen` | `go mod download` + verify + fail on a changed lock          |
| `mise run lint`      | `golangci-lint` (incl. `gofumpt`) + `go vet` + tidy + `actionlint` |
| `mise run format`    | `gofumpt -w .`                                                    |
| `mise run test`      | `go test -race` with a coverage floor                             |
| `mise run build`     | `go build ./...`                                                  |
| `mise run ci`        | Full gate: lint + test + build                                    |
| `mise run vulncheck` | `govulncheck` against the Go vulnerability database               |
| `mise run audit`     | `vulncheck` + `zizmor` over workflows and dependabot config       |
| `mise run ci-watch`  | Watch GitHub Actions for the current branch                       |

`ci` is offline. `vulncheck` and `audit` need network access, so they
are separate; CI runs each as its own job.

## Structure

```
.github/workflows/ci.yml  CI: mise run lint/build/test + govulncheck + zizmor
.github/dependabot.yml    Weekly gomod + github-actions updates, 7-day cooldown
.mise.toml                Pinned toolchain + every repo task
.golangci.yml             golangci-lint v2 configuration
go.mod                    Module path, language floor, minimum toolchain
main.go                   Placeholder CLI entrypoint
main_test.go              Placeholder test
scripts/init.py           Rename-to-your-project helper (`mise run init`)
docs/spec/                Feature specifications
```

Layout conventions as the project grows: private packages under
`internal/<feature>/`, feature-oriented rather than layer-oriented. Add
`cmd/<binary>/` only once there is more than one binary.

## Guidelines

**Code quality:**

- `go vet ./...` and `golangci-lint run` must report zero issues.
- Code must be `gofumpt`-formatted and `goimports`-clean; do not
  hand-format around them. `mise run lint` covers this.
- Tests for all functionality; prefer the stdlib `testing` package.
- Use `t.Context()`, `t.Setenv`, `t.Chdir`, and `testing/synctest` where
  they fit.
- No bare `//nolint`. Narrow it and name the reason
  (`//nolint:gosec // <reason>`); `nolintlint` enforces that. Prefer
  fixing the cause.
- Never weaken a control to make a check pass: no lowered coverage floor,
  no unpinned actions or tools, no deleted tests.

**Supply chain:**

- `go.sum` is committed and must stay in the tree (there is none yet —
  this repo has no dependencies).
- CI installs with `install-frozen`; use plain `mise run install` when
  deliberately changing dependencies. Go has no `--frozen-lockfile`, so
  the frozen task adds `go mod verify` plus a `git diff --exit-code` on
  `go.mod`/`go.sum` — `-mod=readonly` alone does not cover `go.sum`.
- `go mod tidy -diff` must be clean before committing.
- `mise run vulncheck` before shipping a dependency bump.
- Pin GitHub Actions to full-length commit SHAs; `zizmor` enforces the
  hash. The trailing `# vX.Y.Z` comment is convention only — check the
  SHA when it matters.
- Every `.mise.toml` tool is exact-pinned and invisible to dependabot;
  refresh with `mise up` and read the diff.
- `mise.lock` checksums only cover platforms someone has installed on
  (linux-x64 and macos-arm64 today); `govulncheck` has none on any, being
  authenticated by the Go checksum database. See `.mise.toml`.
- `.mise.toml`'s `go` entry is the only exact toolchain pin. `go.mod`'s
  `toolchain` is a minimum and its `go` directive the language floor;
  keep `toolchain` equal to `.mise.toml` and bump them together.

## Commit Message Convention

Follow [Conventional Commits](https://conventionalcommits.org/):

**Format:** `type(scope): description`

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `build`, `ci`, `perf`, `revert`, `improvement`, `chore`

## Session Completion

Work is not complete until every change is committed, pushed, and CI passes.

1. `mise run ci` (or the tasks that changed)
2. Commit everything — do not leave the working tree dirty
3. `git pull --rebase && git push`
4. `mise run ci-watch`; on failure `gh run view --log-failed`, fix, repeat

Never stop before CI is green.
