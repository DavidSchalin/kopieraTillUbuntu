package main

import (
	"golang.org/x/tour/wc"
	"strings"
)

func WordCount(s string) map[string]int {
	words := strings.Fields(s)
	m := make(map[string]int)
	for i := 0; i < len(words); i++ {
		str := words[i]
		m[str] += 1
	}
	return m
}

func main() {
	wc.Test(WordCount)
}
