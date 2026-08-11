module github.com/lsimons/lsimons-template-go

// Language version floor. Deliberately a minor version: it states which
// Go language features this module may use, not which toolchain builds
// it. The exact toolchain pin is the `toolchain` line below and the
// `go` entry in .mise.toml, which must agree with it.
go 1.26

toolchain go1.26.5
