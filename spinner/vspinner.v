module spinner

import term
import time

struct SpinnerState {
mut:
	running bool
}

pub struct Spinner {
mut:
	state          shared SpinnerState
	running_thread thread
}

const (
	default_spinner = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏']
	default_speed   = 80 * time.millisecond
)

pub fn (mut self Spinner) start() {
	term.hide_cursor()
	lock self.state {
		self.state.running = true
	}
	self.running_thread = spawn self.start_thread()
}

pub fn (mut self Spinner) stop() {
	term.show_cursor()
	lock self.state {
		self.state.running = false
	}
	self.running_thread.wait()
}

fn (mut self Spinner) start_thread() {
	mut index := 0
	for {
		rlock self.state {
			if self.state.running == false {
				return
			}
		}
		current_position := term.get_cursor_position() or {
			term.Coord{
				x: 0
				y: 0
			}
		}
		term.set_cursor_position(x: 0, y: current_position.y)
		print(term.green(spinner.default_spinner[index]))
		term.set_cursor_position(x: 0, y: current_position.y)

		time.sleep(spinner.default_speed)

		index++
		if index == spinner.default_spinner.len {
			index = 0
		}
	}
}
