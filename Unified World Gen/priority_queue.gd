class_name PriorityQueue
extends Resource

var _heap: Array[PriorityQueueElement]

func push(value: Variant, priority: Variant) -> void:
	var push_element = PriorityQueueElement.new(value, priority)
	_heap.append(push_element)
	_sift_up(_heap.size() - 1)


func pop() -> Variant:
	if _heap.is_empty():
		return null
	
	var top_value = _heap[0].value
	var last_item = _heap.pop_back()
	
	if not _heap.is_empty():
		_heap[0] = last_item
		_sift_down(0)
	
	return top_value


func erase(value: Variant) -> void:
	for i in range(_heap.size() - 1, -1, -1):
		if _heap[i].value == value:
			erase_at(i)


func erase_at(index: int) -> void:
	var last_index = _heap.size() - 1
	if index == last_index:
		_heap.pop_back()
		return
	
	_swap(index, last_index)
	_heap.pop_back()
	
	_sift_down(index)
	_sift_up(index)


func size() -> int:
	return _heap.size()


func _sift_up(index: int) -> void:
	if index <= 0:
		return
	
	var new_index = (index - 1) / 2
	if _heap[index].priority > _heap[new_index].priority:
		_swap(index, new_index)
		_sift_up(new_index)


func _sift_down(index: int) -> void:
	var length = _heap.size()
	var left_index = 2 * index + 1
	var right_index = 2 * index + 2
	var smallest_index = index
	
	if left_index < length and _heap[left_index].priority > _heap[smallest_index].priority:
		smallest_index = left_index
	if right_index < length and _heap[right_index].priority > _heap[smallest_index].priority:
		smallest_index = right_index
	
	if smallest_index != index:
		_swap(index, smallest_index)
		_sift_down(smallest_index)


func _swap(a: int, b: int) -> void:
	var temp = _heap[a]
	_heap[a] = _heap[b]
	_heap[b] = temp


class PriorityQueueElement:
	var value: Variant
	var priority: Variant
	
	func _init(v: Variant, p: Variant) -> void:
		value = v
		priority = p
