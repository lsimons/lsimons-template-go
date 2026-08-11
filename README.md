# lsimons-template-go

Project template for Go CLI tools with standardized tooling.

## Using This Template

1. Click **Use this template** on GitHub (or clone this repo).
2. Clone your new repo locally and run:

   ```bash
   mise trust            # once per clone: trust this repo's .mise.toml
   mise install          # pin + install the toolchain
   mise run init         # rename `template` → your project name
   mise run build        # confirm it compiles
   ```

   `mise run init` auto-detects your project name from the git remote
   (or directory name), stripping `lsimons-` / `-go` suffixes. Pass
   `--name foo` to override. See `scripts/init.py` for details.

3. Update `AGENTS.md` (and its `CLAUDE.md` symlink) with
   project-specific instructions, and `README.md` with what the project
   actually is.
4. Replace the `main.go` and `main_test.go` placeholders with your real
   implementation. Add private packages under `internal/<feature>/` as
   the project grows; only introduce `cmd/<binary>/` when you have more
   than one binary.
5. Raise the coverage floor in `.mise.toml`'s `test` task once there is
   real code to cover. It ships at 50%, which is what the placeholder
   measures.
6. Run `/setup` in your agent of choice. Repository settings — issue
   labels, private vulnerability reporting, Dependabot security updates
   — are GitHub state rather than files, so `Use this template` does not
   copy them and nothing in this repo can create them. `/setup`
   configures them against the new repo directly.

## Included Configuration

- **Go 1.26** language floor, with the exact toolchain pinned in both
  `go.mod` (`toolchain`) and `.mise.toml`
- **golangci-lint v2** for linting (`.golangci.yml`)
- **gofumpt + goimports** for formatting (enforced via golangci-lint)
- **`go test -race`** with an enforced coverage floor
- **[govulncheck](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)**
  against the Go vulnerability database, locally and in CI
- **GitHub Actions CI** on push/PR to main, with actions pinned to
  full-length commit SHAs, an [actionlint](https://github.com/rhysd/actionlint)
  workflow check and a [zizmor](https://docs.zizmor.sh/) workflow-security
  audit
- **Dependabot** for `gomod` and `github-actions`, weekly, with a 7-day
  cooldown
- **`.mise.toml`** pins every tool to an exact version — go included —
  and defines every repo task
- **`.editorconfig`** so editors that are not running gofumpt still
  agree with it

## Project Structure

```
lsimons-template-go/
├── .github/workflows/ci.yml  # CI pipeline (mise-action + govulncheck + zizmor)
├── .github/dependabot.yml    # Weekly dependency updates
├── .editorconfig             # Editor defaults
├── .golangci.yml             # Linter configuration
├── .mise.toml                # Toolchain pin + task runner
├── docs/spec/                # Feature specifications
├── scripts/init.py           # Rename-to-your-project helper
├── main.go                   # CLI entrypoint (placeholder)
├── main_test.go              # Placeholder test
├── AGENTS.md                 # AI agent instructions
├── CLAUDE.md -> AGENTS.md    # Claude Code compatibility
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE                   # Apache-2.0
├── SECURITY.md               # Vulnerability reporting route
├── go.mod                    # Module definition
└── README.md
```

Once the module has dependencies, `go.sum` joins this list. It is the
lock file: committed, and never gitignored.

`CLAUDE.md` is a git symlink (mode `120000`). A Windows clone needs
`core.symlinks` enabled to get a real link rather than a text file
containing the target path.

## Development Commands

```bash
mise trust            # once per clone
mise install          # one-time: pin + install toolchain
mise run install      # go mod download
mise run build        # go build ./...
mise run test         # go test -race, with the coverage floor
mise run lint         # golangci-lint + gofmt + vet + tidy check + actionlint
mise run fmt-check    # gofmt -l . only (lint depends on it)
mise run format       # gofumpt -w .
mise run ci           # full CI gate (offline)
mise run vulncheck    # govulncheck against the Go vulnerability database
mise run audit        # vulncheck + zizmor over workflows and dependabot config
mise run ci-watch     # watch GitHub Actions for the current branch
```

## License

See [LICENSE](./LICENSE).

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md). AI agents see
[AGENTS.md](./AGENTS.md).

## Security

See [SECURITY.md](./SECURITY.md).
