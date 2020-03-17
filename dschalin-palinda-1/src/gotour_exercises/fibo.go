package main

import (
	"fmt"
)

// fibonacci is a function that returns
// a function that returns an int.
func fibonacci() func() int {
	int1 := -1
	int2 := 0
	return func() int {
		if int1 <= 0 {
			int1++
			return int1
		}
		sum := int1 + int2
		int2 = int1
		int1 = sum
		return sum
	}
}

func main() {
	f := fibonacci()
	for i := 0; i < 10; i++ {
		fmt.Println(f())
	}
}
