extends Node3D

@export var player: Node3D
var world: WorldData

## === Tick ===
var tick_timer: Timer
@export var tick_timer_intervals: float= 0.05
@export var max_adds_per_tick:= 2
@export var max_removes_per_tick:= 2

## === Managerial ===
@onready var STACK_SCENE = preload("uid://dpk7a3skb4ddn")

@export var stack_load_radius: int= 5
@export var stack_unload_radius: int= 7
@export var stack_idle_timeout: float= 5.0

var active_stacks: Dictionary[Vector2i, Stack]
var current_stack:= Vector2i.ZERO
var previous_stack:= Vector2i.MAX

## === Queues/Threads ===
var add_queue:= PriorityQueue.new()
var add_lookup: Dictionary= {}
var remove_queue:= Queue.new()
var remove_lookup: Dictionary= {}

func _ready() -> void:
	tick_timer = Timer.new()
	tick_timer.name = "Tick Timer"
	tick_timer.wait_time = tick_timer_intervals
	tick_timer.autostart = true
	tick_timer.one_shot = false
	add_child(tick_timer, true)
	tick_timer.timeout.connect(_process_tick)


func _process(delta: float) -> void:
	if not world:
		return
	
	if player:
		current_stack = Vector2i(
			floori(player.position.x / world.chunk_size_physical),
			floori(player.position.z / world.chunk_size_physical)
		)
	
	if current_stack != previous_stack:
		check_nearby_stacks()
		previous_stack = current_stack
	check_active_stacks(delta)


func _process_tick() -> void:
	check_add_queue()
	check_remove_queue()


## === Updating ===
func check_nearby_stacks() -> void:
	for x in range(-stack_load_radius, stack_load_radius + 1):
		for z in range(-stack_load_radius, stack_load_radius + 1):
			var coord = current_stack + Vector2i(x, z)
			var distance = coord.distance_to(current_stack)
			if distance <= stack_load_radius:
				add_to_add_queue(coord, distance)


func check_active_stacks(delta: float) -> void:
	for coord in active_stacks:
		var distance = current_stack.distance_to(coord)
		
		if distance <= stack_load_radius:
			active_stacks[coord].idle_time = 0
		elif distance < stack_unload_radius:
			active_stacks[coord].idle_time += delta
			if active_stacks[coord].idle_time >= stack_idle_timeout:
				add_to_remove_queue(coord)
		else:
			add_to_remove_queue(coord)


## === Add Queue ===
func add_to_add_queue(coord: Vector2i, distance: float) -> void:
	if active_stacks.has(coord):
		return
	
	if add_lookup.has(coord):
		return
	
	if remove_lookup.has(coord):
		# remove from @var:remove_queue too, right?
		remove_lookup.erase(coord)
	
	add_lookup[coord] = true
	add_queue.push(coord, distance)


func check_add_queue() -> void:
	var counter = 0
	while add_queue.size() > 0 and counter < max_adds_per_tick:
		var coord = add_queue.pop()
		add_lookup.erase(coord)
		if active_stacks.has(coord):
			continue
		
		## Get Stack data:
		var chunks: Array[ChunkData] = []
		for y in range(world.world_chunk_count.y):
			chunks.append(world.get_atlas_chunk(Vector3i(coord.x, y, coord.y)))
		## Create Stack:
		var stack = STACK_SCENE.instantiate()
		stack.build(chunks)
		stack.position = Vector3(coord.x, 0, coord.y) * world.world_size_physical
		stack.name = "Stack(%s,%s)" % [coord.x, coord.y]
		## Add Stack:
		active_stacks[coord] = stack
		$"Stack Holder".add_child.call_deferred(stack, true)
		counter += 1


## === Remove Queue ===
func add_to_remove_queue(coord: Vector2i) -> void:
	if not active_stacks.has(coord):
		return
	
	if remove_lookup.has(coord):
		return
	
	if add_lookup.has(coord):
		# remove from @var:add_queue too, right?
		add_lookup.erase(coord)
	remove_lookup[coord] = true
	remove_queue.push(coord)


func check_remove_queue() -> void:
	var counter = 0
	while remove_queue.size() > 0 and counter < max_removes_per_tick:
		var coord = remove_queue.pop()
		remove_lookup.erase(coord)
		if not active_stacks.has(coord):
			continue
		
		var stack = active_stacks[coord]
		if not is_instance_valid(stack):
			continue
		
		## TODO: Save Data
		active_stacks.erase(coord)
		stack.queue_free()
		counter += 1
