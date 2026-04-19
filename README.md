# lsimons-template-go

Project template for Go CLI tools with standardized tooling.

## Using This Template

1. Click **Use this template** on GitHub (or clone this repo).
2. Clone your new repo locally and run:

   ```bash
   mise install          # pin + install go + golangci-lint + gofumpt
   mise run init         # rename `template` → your project name
   mise run build        # confirm it compiles
   ```

   `mise run init` auto-detects your project name from the git remote
   (or directory name), stripping `lsimons-` / `-go` suffixes. Pass
   `--name foo` to override. See `scripts/init.py` for details.

3. Update `AGENTS.md` (and `CLAUDE.md` symlink) with project-specific
   instructions.
4. Replace `main.go` placeholder with your CLI entrypoint. Add private
   packages under `internal/<feature>/` as the project grows. Only
   introduce `cmd/<binary>/` when you have more than one binary.

## Included Configuration

- **Go 1.26+** required (toolchain pinned in `go.mod` + `.mise.toml`)
- **golangci-lint v2** for linting (`.golangci.yml`)
- **gofumpt + goimports** for formatting (enforced via golangci-lint)
- **`go test -race -cover`** for tests and coverage
- **GitHub Actions CI** on push/PR to main, with actions pinned to
  full-length commit SHAs (the repo setting *Require actions to be
  pinned to a full-length commit SHA* is enabled)
- **`.mise.toml`** pins toolchain + defines every repo task

## Project Structure

```
lsimons-template-go/
├── .github/workflows/ci.yml  # CI pipeline (mise-action)
├── .mise.toml                # Toolchain pin + task runner
├── docs/spec/                # Feature specifications
├── internal/                 # Private packages (add as needed)
├── scripts/init.py           # Rename-to-your-project helper
├── main.go                   # CLI entrypoint (placeholder)
├── main_test.go              # Placeholder test
├── .golangci.yml             # Linter configuration
├── AGENTS.md                 # AI agent instructions
├── CLAUDE.md -> AGENTS.md    # Claude Code compatibility
├── go.mod                    # Module definition
└── README.md
```

## Development Commands

```bash
mise install          # one-time: pin + install toolchain
mise run build        # go build ./...
mise run test         # go test -race -cover ./...
mise run lint         # golangci-lint + gofmt + vet + mod tidy check
mise run format       # gofumpt -w .
mise run ci           # full CI gate
```

## License

See [LICENSE.md](./LICENSE.md).

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).
