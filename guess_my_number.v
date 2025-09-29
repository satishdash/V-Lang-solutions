module main

import rand
import readline
import strconv


fn verify(secret int, guess int) bool {
	if secret == guess {
		return true
	}
	else if guess < secret {
		println('Too low!')
		return false
	}
	else {
		println('Too high!')
		return false
	}
}

fn play(start int, end int, secret int) {
	println('I\'m thinking of a number between ${start} and ${end}.')
	for {
		// Ask the user to input a guess
		guess := readline.read_line('Please input your guess: ') or {
			println('[X] Failed to read your input, Please enter a valid input on restart!')
			return
		}
		guess_number := strconv.atoi(guess) or {
			println('[X] Failed to parse [${guess}] as a valid integer, Please enter a valid integer again!')
			continue
		}

		if verify(secret, guess_number) {
			println('You\'ve guessed it right!, my number was *${secret}*')
			return
		}
	}
	
}

fn main() {
	// This number guessing game is built on binary search
	start := 1
	end := 100
	secret := start + rand.intn(end - start + 1) or {
		println('Failed to decide on a number between ${start} and ${end} inclusive!')
		return
	}
	play(start, end, secret)
}
