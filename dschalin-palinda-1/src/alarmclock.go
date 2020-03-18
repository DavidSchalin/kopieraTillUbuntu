package main

import (
	"fmt"
	"time"
)

func Remind(text string, delay time.Duration)  {
	t0 := time.Now()
	for true {
		if time.Since(t0).Seconds() >= delay.Seconds(){
			t := time.Now()
			str := t.Format("15:04:05")
			fmt.Println("The time is", str, ":", text)
			t0 = time.Now()
		}
	}
}

func main()  {
	go Remind("Time to eat", 10*time.Second)
	go Remind("Time to work", 30*time.Second)
	Remind("Time to sleep", 60*time.Second)
}