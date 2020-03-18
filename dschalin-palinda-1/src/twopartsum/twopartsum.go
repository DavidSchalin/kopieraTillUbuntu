package main

import (
	"fmt"
)

// sum the numbers in a and send the result on res.
func sum(a []int, res chan<- int) {
	sum := 0
	for i := 0; i < len(a); i++ {
		sum += a[i]
	}
	res <- sum
}

// concurrently sum the array a.
func ConcurrentSum(a []int) int {
	n := len(a)
	ch := make(chan int)
	go sum(a[:n/2], ch)
	go sum(a[n/2:], ch)

	sum := 0

	for i := 0; i < 2; i++ {
		b := <- ch
		sum += b
	}
	return sum
}

func main() {
	// example call
	a := []int{1, 2, 3, 4, 5, 6, 7}
	x := ConcurrentSum(a)
	fmt.Println(x)
}
