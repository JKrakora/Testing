class_name Queue
extends Resource

var _head: QueueElement
var _tail: QueueElement
var _length: int

func push(value: Variant) -> void:
	var push_element = QueueElement.new(value)
	if _head == null:
		_head = push_element
		_tail = push_element
	else:
		_tail.next = push_element
		push_element.prev = _tail
		_tail = push_element
	_length += 1


func pop() -> Variant:
	if not _head:
		return null
	
	var pop_value = _head.value
	_head = _head.next
	
	_length -= 1
	if _length == 0:
		_tail = null
	
	return pop_value


func size() -> int:
	return _length


func erase_if_present(value: Variant) -> void:
	var iterator = _head
	while iterator:
		if iterator.value == value:
			pass


class QueueElement:
	var value: Variant
	var next: QueueElement
	var prev: QueueElement
	
	func _init(v: Variant) -> void:
		value = v
		next = null
		prev = null
