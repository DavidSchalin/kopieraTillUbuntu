package main

import (
	"fmt"
	"math"
)

func Sqrt(x float64) (float64, float64) {
	counter := 0
	z := x/2
	oldz := x
	for ; (equal(oldz, z) == false); {
		oldz = z
		z -= (z*z - x) / (2*z)
		if equal(oldz, z) {

			return z, float64(counter)
		}
		counter++
	}
	return z, float64(counter)
}

func equal(a, b float64) bool {

	if a > b {
		if a-b < 0.00001 {
			return true
		}
	}
	return false
}

func main() {
	floater, counting := Sqrt(10)
	fmt.Println("Square root of 10 according to my code:", floater)
	fmt.Println("Square root of 10 according to math.Sqrt(10):", math.Sqrt(10))
	fmt.Println("10 - Sqrt(10)^2 :", float64(10) - (math.Pow(floater, 2)))
	fmt.Println("Loop broke after:", counting, "iterations")
}
