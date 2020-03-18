package main

import "golang.org/x/tour/pic"

func Pic(dx, dy int) [][]uint8 {
	x := make([]uint8, dx)
	y := make([][]uint8, dy)
	for i, v := range x {
		x[v] = uint8(i + dx/24)
	}
	for v := range y {
		y[v] = x
	}

	return y

}

func main() {
	pic.Show(Pic)
}