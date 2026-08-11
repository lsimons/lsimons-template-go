// `mise run init` rewrites this path. It reassembles `lsimons-<name>-go`
// from a short name derived from the git remote, so check the result
// really matches your repo — a repo not named `lsimons-<name>-go` gets a
// module path that does not resolve. See scripts/init.py.
module github.com/lsimons/lsimons-template-go

// Language version floor. Deliberately a minor version: it states which
// Go language features this module may use, not which toolchain builds
// it.
go 1.26

// A *minimum* toolchain, not an exact pin: a newer local go is used as
// found and never downgraded to this. The exact pin is the `go` entry in
// .mise.toml, which is what mise installs. Keep the two equal.
toolchain go1.26.5
