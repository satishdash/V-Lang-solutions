module main

enum Priority {
	low
	medium
	high
}



struct TodoItem {
	description string
mut:
	completed bool		
	priority Priority
}

fn print_list(items []TodoItem) {
	println('--- To-Do List ---')
	for i, item in items {
		marker := if item.completed { 'x' } else { ' ' }
		priority := match item.priority {
			.low { 'L' }
			.medium { 'M' }
			.high { 'H' }
		}
		println('[$marker] ${i + 1}. ${item.description} (${priority})')
	}
}

fn add_item(mut items []TodoItem, description string, priority Priority) {
	items << TodoItem{
		description: description,
		priority: priority
	}
}

fn complete_item(mut items []TodoItem, index int) {
	// Add a check to prevent crashing if the index is out of bounds
	if index < 0 || index >= items.len {
		println('Error: Invalid index ${index}.')
		return
	}
	items[index].completed = true
	println('--- List Updated ---')
}

fn main() {
	mut items := []TodoItem{}

	add_item(mut items, 'Learn V functions', Priority.high)
	add_item(mut items, 'Build the To-Do app', Priority.medium)
	add_item(mut items, 'Get some sleep', Priority.high)

	print_list(items)

	complete_item(mut items, 0)

	print_list(items)
}
