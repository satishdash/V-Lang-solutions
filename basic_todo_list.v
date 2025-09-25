module main

struct TodoItem {
	description string
mut:
	completed bool
}

fn print_list(items []TodoItem) {
	println('--- To-Do List ---')
	for i, item in items {
		marker := if item.completed { 'x' } else { ' ' }
		println('[$marker] ${i + 1}. ${item.description}')
	}
}

fn add_item(mut items []TodoItem, description string) {
	items << TodoItem{description: description}
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

	add_item(mut items, 'Learn V functions')
	add_item(mut items, 'Build the To-Do app')
	add_item(mut items, 'Get some sleep')

	print_list(items)

	complete_item(mut items, 0)

	print_list(items)
}
