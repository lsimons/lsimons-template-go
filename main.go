// Command template is a placeholder entrypoint. Replace with real CLI logic.
package main

import (
	"fmt"
	"os"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	_ = args
	fmt.Println("hello from lsimons-template")
	return nil
}
