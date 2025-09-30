module main


import os
import time
import readline


const sep := '] - '
const timestamp_format := 'YYYY-MM-DD hh:mm:ss'

struct FileInput {
	lineno int
	utc_timestamp time.Time
	data string
}


fn get_user_input(last_lineno int) ?FileInput {
	user_input := readline.read_line('Please enter a line for your journal: ') or {
		eprintln('Failed to read input. Error=[${err}]')
		return none
	}
	return FileInput{lineno: last_lineno, utc_timestamp: time.utc(), data: user_input}
}

fn display_file_content(file_inputs []FileInput) {
	for input in file_inputs {
		println('${input.lineno}. [${input.utc_timestamp.format_ss()}] - ${input.data}')
	}
}

fn read_file_content(path string) []FileInput {
	mut file_inputs := []FileInput{}
	lines := os.read_lines(path) or {
		eprintln('Failed to read line from \'${path}\'. Error=[${err}]')
		return file_inputs
	}

	for line_no, line in lines {
		// Split the line into time stamp and content, then save
		timestamp, content := line.split_once(sep) or {
			eprintln('Failed to identify journal entry with timestamp. Error=[${err}] *line_no=${line_no+1}, line=${line}*')
			continue
		}
		
		// Parse the timestamp to be able to store in the struct
		t := time.parse_format(timestamp[1..].trim_indent(), timestamp_format) or {
			eprintln('Failed to parse timestamp. Error=[${err}]. *lineno=${line_no+1}, line=${line}*')
			continue
		}
		
		// Append to the array
		file_inputs << FileInput{lineno: line_no+1, utc_timestamp: t, data: content}

	}
	return file_inputs
}

fn write_file_content(mut file os.File, fin FileInput) {
	file.writeln('[${fin.utc_timestamp.format_ss()}] - ${fin.data}') or {
		eprintln('Failed to append user input to the file. Error=[${err}]')
	}
}

fn file_ops(path string) {
	// Display file content
	println('--- Initial file content ---')
	mut file_inputs := read_file_content(path)
	display_file_content(file_inputs)

	// Write file content
	println('\n--- Appending file content ---')
	mut wfile := os.open_file(path, 'a') or {
		eprintln('Failed to open or create file \'${path}\' for writing. Error=[${err}]')
		return
	}
	uin := get_user_input(file_inputs.len) or {
        	eprintln('Failed to obtain user input. Error=[${err}]')
		return
	}
	write_file_content(mut wfile, uin)
	wfile.close()

	// Display file content after write
	println('\n--- Updated file content ---')
	file_inputs = read_file_content(path)
	display_file_content(file_inputs)
}

fn main() {
	path := '/tmp/journal.txt'
	file_ops(path)
}
