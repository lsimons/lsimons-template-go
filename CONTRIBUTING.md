# Contributing

Thank you for investing your time in contributing to our project!

Any contributions you make are governed by our [License](LICENSE).

Please follow our [Code of Conduct](CODE_OF_CONDUCT.md) to keep our community approachable and respectable.

Do not open a public issue for a security problem. Use the "Report a vulnerability" button under this repository's Security tab instead.

## Working on a change

```bash
mise trust            # once per clone
mise install          # install the pinned toolchain
mise run install      # download module dependencies
mise run ci           # lint + test + build — must pass before you push
```

`mise.lock` pins a checksum for every tool, but only for platforms
someone has installed on: currently linux-x64 and macos-arm64. If you
work on another platform, `mise install` will fetch the toolchain
without verifying it against a recorded hash. Commit the `mise.lock`
entries your install adds — that extends the guarantee to the next
person on your platform.

Commit messages follow [Conventional Commits](https://conventionalcommits.org/):
`type(scope): description`.

Open a pull request against `main`. CI runs the same `mise run ci` gate
plus a [govulncheck](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)
scan of the Go dependencies and a [zizmor](https://docs.zizmor.sh/) audit
of the GitHub Actions workflows; all three must be green.

AI agents: see [AGENTS.md](AGENTS.md).

You could read the [GitHub Docs Contributing Guide](https://github.com/github/docs/blob/main/CONTRIBUTING.md) for general advice on how to contribute.

Since this is a small hobby project, your contribution may not be noticed for a while if we are busy elsewhere. Sorry!
