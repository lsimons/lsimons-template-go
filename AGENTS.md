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
  hand-format around them. `golangci-lint run` reports formatter diffs
  as issues, so `mise run lint` already covers this — there is no
  separate `gofmt` check, and none is needed.
- Tests for all functionality; prefer the stdlib `testing` package.
- Use `t.Context()`, `t.Setenv`, `t.Chdir`, and `testing/synctest` where
  they fit.
- `go mod tidy -diff` must be clean before committing.
- Do not silence a check without a written justification on the same
  line — a bare `//nolint` is not acceptable, a narrow
  `//nolint:gosec // <reason>` is. `nolintlint` enforces that. Prefer
  fixing the cause; suppress when the cause is outside this repo.
- Never weaken a control to make a check pass: do not lower the
  coverage floor, unpin an action or a tool, or delete a failing test.

**Supply chain:**

- `go.sum` is committed and must stay in the tree. (This repo has no
  dependencies yet, so there is none to commit — the moment one is added
  there will be.)
- CI installs with `install-frozen`, never plain `install`. Go has no
  `--frozen-lockfile`: `-mod=readonly` is the default but governs
  `go.mod` only, so `go mod download` and `go build` will both write or
  extend `go.sum` and exit 0. The frozen task adds `go mod verify` and a
  `git diff --exit-code` on `go.mod`/`go.sum`, which is what actually
  makes a stale lock an error.
- GitHub Actions are pinned to full-length commit SHAs, and `zizmor`
  enforces the hash pin in CI. The trailing `# vX.Y.Z` comment is
  convention only — nothing validates that it matches the SHA, so read
  it as a hint and check the SHA when it matters.
- Every tool in `.mise.toml` is pinned to an exact version, go included.
  Nothing there is covered by dependabot, so refresh it deliberately
  with `mise up` and read the diff.
- `mise.lock`'s checksums are per platform, and only cover platforms
  someone has installed on — linux-x64 and macos-arm64 today. Elsewhere
  the pin is a version string with nothing verifying the bytes. The
  `go:` govulncheck entry has no mise checksum on any platform; it is
  authenticated by the Go checksum database instead.
- `.mise.toml`'s `go` entry is the only exact toolchain pin. `go.mod`'s
  `toolchain` directive is a *minimum* — a newer local go is used as
  found — and its `go` directive is the language floor. Keep `toolchain`
  equal to `.mise.toml`'s `go` and bump them together.
- `mise run vulncheck` before shipping a dependency bump.

## Commit Message Convention

Follow [Conventional Commits](https://conventionalcommits.org/):

**Format:** `type(scope): description`

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `build`, `ci`, `perf`, `revert`, `improvement`, `chore`

## Session Completion

Work is NOT complete until every change is committed, pushed, and CI passes.

1. **Quality gates** (if code changed):
   ```bash
   mise run ci
   ```

2. **Commit**: stage and commit every change from this session. Do not leave the working tree dirty.
   ```bash
   git status              # review untracked and unstaged files
   git add <files>
   git commit -m "<type>(<scope>): <description>"
   ```

3. **Push**:
   ```bash
   git pull --rebase && git push
   git status  # must show "up to date with origin"
   ```

4. **Verify CI**:
   ```bash
   mise run ci-watch
   ```
   On failure, inspect with `gh run view --log-failed`, fix, commit, push, and re-watch.

Never stop before CI is green. If anything fails, resolve and retry.
