package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "usage: match <regexp>  # prints matching lines from stdin\n")
		os.Exit(2)
	}

	re, err := regexp.Compile(os.Args[1])
	if err != nil {
		fmt.Fprintf(os.Stderr, "invalid regex: %v\n", err)
		os.Exit(2)
	}

	output := bufio.NewWriter(os.Stdout)
	defer output.Flush()

	num := 0
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		line := scanner.Text()
		if re.MatchString(line) {
			fmt.Fprintln(output, line)
			num++
		}
	}
	if num == 0 {
		os.Exit(1)
	}
}
