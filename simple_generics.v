module main


enum Status {
	in_progress
	failed
	succeeded
}


struct Task {
	id int
	name string
	mut:
		status Status
}


struct Result[T] {
	mut:
		data T
		error string
}


fn display_result[T](res Result[T], title string) {
	println('--- ${title} Result ---\n')
	println('Data: ${res.data}\n')
	println('Error: ${res.error}\n')
}


fn main() {
	// Primitive types
	int_res := Result[int]{data: 123, error: ''}
	str_res := Result[string] {data: '', error: 'Failed to fetch user data'}
	display_result(int_res, 'int')
	display_result(str_res, 'string')
	
	// Custom types
	mut task1 := Task{id:111, name: 'Simple Task1', status: Status.in_progress}
	mut task2 := Task{id: 222, name: 'Simple Task2', status: Status.in_progress}
	mut task1_res := Result[Task]{data: task1, error: ''}
	mut task2_res := Result[Task]{data: task2, error: ''}
	display_result(task1_res, 'task1 progress')
	display_result(task2_res, 'task2 progress')
	
	task1.status = Status.succeeded
	task1_res.data = task1
	task2.status = Status.failed
	task2_res.data = task2
	task2_res.error = 'Failed execution'
	display_result(task1_res, 'task1 completed')
	display_result(task2_res, 'task2 completed')
}
