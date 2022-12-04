package service

import (
	"math/rand"
	"time"
)

var numbers []int

func init() {
	// 番号初期化
	numbers = []int{}
}

func ResetNumber() {
	// 番号初期化
	numbers = []int{}
}

func RandNumber() int {
	rand.Seed(time.Now().Unix())
	breakNum := 0
	result := make(chan int)

	go func() {
		for {
			num := rand.Intn(100)
			defer close(result)
			isLoop := false
			for _, number := range numbers {
				if num == number {
					isLoop = true
				}
			}
			if num <= 0 {
				isLoop = true
			}
			if !isLoop {
				// 値を追加
				numbers = append(numbers, num)
				result <- num
			}
			// 試行回数が100回を超えたら強制的に抜ける
			breakNum++
			if breakNum > 100 {
				result <- num
			}
		}
	}()

	res := <-result
	return res
}
