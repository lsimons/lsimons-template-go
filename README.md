# lsimons-template-go

Project template for Go CLI tools with standardized tooling.

## Using This Template

1. Copy this repository to create a new project
2. Replace placeholders throughout:
   - `$project` - project name (e.g., `myproject`)
   - `$shortDescription` - one-line description

3. Update `go.mod`:
   - Replace `$project` in the module path with your project name (the
     template will not build until this is done — that is intentional)
   - Bump the `go` and `toolchain` directives if needed

4. Replace `main.go` with your CLI entrypoint. Add private packages under
   `internal/<feature>/` as the project grows. Only introduce `cmd/<binary>/`
   when you have more than one binary.

5. Update `AGENTS.md` (and `CLAUDE.md` symlink) with project-specific
   instructions.

## Included Configuration

- **Go 1.26+** required (toolchain pinned in `go.mod`)
- **golangci-lint v2** for linting (`.golangci.yml`)
- **gofumpt + goimports** for formatting (enforced via golangci-lint)
- **`go test -race -cover`** for tests and coverage
- **GitHub Actions CI** on push/PR to main

## Project Structure

```
lsimons-$project/
├── .github/workflows/ci.yml  # CI pipeline
├── docs/spec/                # Feature specifications
├── internal/                 # Private packages (add as needed)
├── main.go                   # CLI entrypoint
├── main_test.go              # Placeholder test
├── .golangci.yml             # Linter configuration
├── AGENTS.md                 # AI agent instructions
├── CLAUDE.md -> AGENTS.md    # Claude Code compatibility
├── go.mod                    # Module definition
└── README.md
```

## Development Commands

```bash
# Build
go build ./...

# Run tests (race detector + coverage)
go test -race -cover ./...

# Lint
golangci-lint run

# Format
gofumpt -w .

# Keep go.mod tidy
go mod tidy
```

Install `golangci-lint` and `gofumpt` once:

```bash
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
go install mvdan.cc/gofumpt@latest
```

## License

See [LICENSE.md](./LICENSE.md).

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).
