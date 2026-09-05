extends Node3D

## Find a way to iterate around neady chunks from inside out instead of a for loop around the player

@export var player: Node3D

## === Compute Stuff ===
var rendering_device: RenderingDevice
var shader: RID
var pipeline: RID

var buffer_set: RID
var params_buffer: RID
const PARAMS_BINDING:= 0
var counter_buffer: RID
var counter_data_bytes
const COUNTER_BINDING:= 1
var triangle_buffer: RID
var triangle_data_bytes
var num_triangles: int
const TRIANGLE_BINDING:= 2

## === Noise Stuff ===
@export_group("Noise Settings")
@export var isolevel:= 0.0
@export var amplitude:= 1.0
@export var frequency:= 1.0
@export var persistence:= 0.5
@export var lacunarity:= 2.0
@export var noise_scale:= 1.0
@export var octaves: int= 3

## === World/Chunk/Voxel Stuff ===
@export_group("World Settings")
@export var world_chunk_count:= Vector3i(50, 10, 50)
var chunk_atlas: Array[ChunkData]
const CHUNK_VOXEL_COUNT:= 8
const CHUNK_SCENE:= preload("uid://s7pi75vwa1ph")
const VOXEL_SIZE_PHYSICAL:= 1.0

var active_chunks: Dictionary[Vector2i, Chunk]
@export var chunk_load_radius: int= 12
var chunk_idle_threshold_seconds: float= 30
@export var chunk_unload_radius: int= 15
var previous_chunk:= Vector2i.MAX

var add_queue:= PriorityQueue.new()
var add_lookup: Dictionary= {}
var remove_queue:= Queue.new()
var remove_lookup: Dictionary= {}
var remove_count_per_frame: int= 4

var pending_mesh_queue:= PriorityQueue.new()
var hotseat: Dictionary

var waiting_for_compute: bool
var waiting_for_mesh: bool
const GPU_WAITFRAME_COUNT: int= 3
var frame: int
var mesh_thread

func _ready() -> void:
	setup_compute()
	chunk_atlas.resize(world_chunk_count.x * world_chunk_count.z)


func _process(delta: float) -> void:
	frame += 1
	
	check_compute_status()
	check_add_queue()
	check_remove_queue()
	
	if not player:
		return
	
	var chunk_size = CHUNK_VOXEL_COUNT * VOXEL_SIZE_PHYSICAL
	var current_chunk = Vector2i(
			floori(player.position.x / chunk_size),
			floori(player.position.z / chunk_size)
	)
	
	if current_chunk != previous_chunk:
		check_nearby_chunks(current_chunk)
		previous_chunk = current_chunk
	
	update_chunk_idle_time(current_chunk, delta)


func check_compute_status() -> void:
	if hotseat:
		if waiting_for_compute and frame - hotseat.submit_frame >= GPU_WAITFRAME_COUNT:
			waiting_for_compute = false
			collect_compute_buffer_data()
			waiting_for_mesh = true
		
		if waiting_for_mesh and not mesh_thread.is_alive():
			waiting_for_mesh = false
			update_chunk_with_new_data()
			hotseat = {}
	elif pending_mesh_queue.size() > 0:
		hotseat = pending_mesh_queue.pop()
		startup_compute()


func collect_compute_buffer_data() -> void:
	rendering_device.sync()
	triangle_data_bytes = rendering_device.buffer_get_data(triangle_buffer)
	counter_data_bytes = rendering_device.buffer_get_data(counter_buffer)
	num_triangles = counter_data_bytes.to_int32_array()[0]
	mesh_thread = Thread.new()
	mesh_thread.start(create_mesh_data.bind(triangle_data_bytes.to_float32_array()))


func create_mesh_data(data: Array) -> Dictionary:
	var num_verts: int= num_triangles * 3
	var vertices:= PackedVector3Array()
	vertices.resize(num_verts)
	var normals:= PackedVector3Array()
	normals.resize(num_verts)
	
	## Even though the output buffer is a list of Tris, which are 4 vec3's, it 
	## actually returns as 4 vec4's. I'm not sure why, but the workaround is
	## simple: Jump by 16 and skip 3, 7, and 11 /within/ the 16.
	for tri_index in range(num_triangles):
		var index = tri_index * 16
		
		var vertex_a = Vector3(data[index + 0], data[index + 1], data[index + 2])
		var vertex_b = Vector3(data[index + 4], data[index + 5], data[index + 6])
		var vertex_c = Vector3(data[index + 8], data[index + 9], data[index + 10])
		vertices[tri_index * 3 + 0] = vertex_a
		vertices[tri_index * 3 + 1] = vertex_b
		vertices[tri_index * 3 + 2] = vertex_c
		
		var norm = Vector3(data[index + 12], data[index + 13], data[index + 14])
		normals[tri_index * 3 + 0] = norm
		normals[tri_index * 3 + 1] = norm
		normals[tri_index * 3 + 2] = norm
	
	return {"vertices": vertices, "normals": normals}


func update_chunk_with_new_data() -> void:
	var array_mesh = create_array_mesh(mesh_thread.wait_to_finish())
	chunk_atlas[hotseat.atlas_index].arraymesh = array_mesh
	var coord = hotseat.coord
	if active_chunks.has(coord):
		active_chunks[coord].set_array_mesh(array_mesh)


func create_array_mesh(data: Dictionary) -> ArrayMesh:
	var mesh_data = []
	mesh_data.resize(Mesh.ARRAY_MAX)
	mesh_data[Mesh.ARRAY_VERTEX] = data.vertices
	mesh_data[Mesh.ARRAY_NORMAL] = data.normals
	
	var array_mesh = ArrayMesh.new()
	if data.vertices.size() > 0:
		array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
	
	return array_mesh


func startup_compute() -> void:
	params_buffer = rendering_device.storage_buffer_create(hotseat.params_bytes.size(), hotseat.params_bytes)
	var params_uniform:= RDUniform.new()
	params_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	params_uniform.binding = PARAMS_BINDING
	params_uniform.add_id(params_buffer)
	
	counter_buffer = rendering_device.storage_buffer_create(hotseat.counter_bytes.size(), hotseat.counter_bytes)
	var counter_uniform:= RDUniform.new()
	counter_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	counter_uniform.binding = COUNTER_BINDING
	counter_uniform.add_id(counter_buffer)
	
	const MAX_TRIS_PER_VOXEL: int= 5 ## Per Marching Cubes Algorithm
	const FLOATS_PER_TRI: int= 4 * 3 ## idk?
	const BYTES_PER_FLOAT: int= 4 ## for float-32
	const BYTES_PER_TRI: int= FLOATS_PER_TRI * BYTES_PER_FLOAT
	var max_triangles: int= MAX_TRIS_PER_VOXEL * ((CHUNK_VOXEL_COUNT + 1) ** 3) * world_chunk_count.y
	var max_bytes: int= BYTES_PER_TRI * max_triangles
	triangle_buffer = rendering_device.storage_buffer_create(max_bytes)
	var triangle_uniform:= RDUniform.new()
	triangle_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	triangle_uniform.binding = TRIANGLE_BINDING
	triangle_uniform.add_id(triangle_buffer)
	
	var uniforms = [params_uniform, counter_uniform, triangle_uniform]
	buffer_set = rendering_device.uniform_set_create(uniforms, shader, 0)
	pipeline = rendering_device.compute_pipeline_create(shader)
	
	var compute_list = rendering_device.compute_list_begin()
	rendering_device.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rendering_device.compute_list_bind_uniform_set(compute_list, buffer_set, 0)
	rendering_device.compute_list_dispatch(compute_list, 1, world_chunk_count.y, 1)
	rendering_device.compute_list_end()
	rendering_device.submit()
	hotseat["submit_frame"] = frame
	waiting_for_compute = true


func check_add_queue() -> void:
	if add_queue.size() == 0:
		return
	
	var coord = add_queue.pop()
	add_lookup.erase(coord)
	if active_chunks.has(coord):
		return
	
	var data = get_chunk_data(coord)
	var chunk = CHUNK_SCENE.instantiate()
	chunk.init(data)
	chunk.position = Vector3(coord.x, 0, coord.y) * CHUNK_VOXEL_COUNT * VOXEL_SIZE_PHYSICAL
	active_chunks[coord] = chunk
	add_child.call_deferred(chunk)


func check_remove_queue() -> void:
	var counter = 0
	while counter < remove_count_per_frame and remove_queue.size() > 0:
		var coord = remove_queue.pop()
		remove_lookup.erase(coord)
		if not active_chunks.has(coord):
			return
		
		var chunk = active_chunks[coord]
		if not is_instance_valid(chunk):
			return
		
		chunk_atlas[get_atlas_index(get_atlas_coord(coord))] = chunk.data
		active_chunks.erase(coord)
		chunk.queue_free()
		
		counter += 1


func check_nearby_chunks(current_chunk: Vector2i) -> void:
	for x in range(-chunk_load_radius, chunk_load_radius + 1):
		for z in range(-chunk_load_radius, chunk_load_radius + 1):
			var coord = current_chunk + Vector2i(x, z)
			var dist = coord.distance_to(current_chunk)
			if dist <= chunk_load_radius:
				add_chunk_to_queue(coord, dist)


func add_chunk_to_queue(coord: Vector2i, dist: float) -> void:
	if active_chunks.has(coord):
		return
	
	if add_lookup.has(coord):
		return
	
	if remove_lookup.has(coord):
		remove_lookup.erase(coord)
	add_lookup[coord] = true
	add_queue.push(coord, dist)


func update_chunk_idle_time(current_chunk: Vector2i, delta: float) -> void:
	for coord in active_chunks:
		var offset = coord - current_chunk
		var dist = offset.length_squared()
		
		## Within Load radius
		if dist <= chunk_load_radius ** 2:
			active_chunks[coord].idle_time = 0
		## Inside Idle ring
		elif dist <= chunk_unload_radius ** 2:
			active_chunks[coord].idle_time += delta
			if active_chunks[coord].idle_time >= chunk_idle_threshold_seconds:
				remove_chunk_from_queue(coord)
		## Outside Unload radius
		else:
			remove_chunk_from_queue(coord)


func remove_chunk_from_queue(coord: Vector2i) -> void:
	if not active_chunks.has(coord):
		return
	
	if remove_lookup.has(coord):
		return
	
	if add_lookup.has(coord):
		add_lookup.erase(coord)
	remove_lookup[coord] = true
	remove_queue.push(coord)


func setup_compute() -> void:
	rendering_device = RenderingServer.create_local_rendering_device()
	var shader_file: RDShaderFile= load("uid://b3x1ujsnm8vga")
	var shader_spirv: RDShaderSPIRV= shader_file.get_spirv()
	shader = rendering_device.shader_create_from_spirv(shader_spirv)


func get_chunk_data(coord: Vector2i) -> ChunkData:
	var atlas_coord = get_atlas_coord(coord)
	var atlas_index = get_atlas_index(atlas_coord)
	if atlas_index < 0 or atlas_index >= chunk_atlas.size():
		return null
	
	## If the chunk already exists in the atlas, just return it:
	if chunk_atlas[atlas_index]:
		return chunk_atlas[atlas_index]
	
	## Otherwise, return empty data and queue its creation:
	var params_bytes = PackedFloat32Array(get_generation_params_array(atlas_coord)).to_byte_array()
	var counter_bytes = PackedInt32Array([0]).to_byte_array()
	pending_mesh_queue.push({
		"coord": coord,
		"atlas_index": atlas_index,
		"params_bytes": params_bytes,
		"counter_bytes": counter_bytes,
	}, 0)
	
	var chunk_data = ChunkData.new()
	chunk_atlas[atlas_index] = chunk_data
	return chunk_data


func get_atlas_coord(global_coord: Vector2i) -> Vector2i:
	return Vector2i(
			posmod(global_coord.x, world_chunk_count.x), 
			posmod(global_coord.y, world_chunk_count.z)
	)


func get_atlas_index(atlas_coord: Vector2i) -> int:
	return atlas_coord.x + (atlas_coord.y * world_chunk_count.x)


func get_generation_params_array(coord:= Vector2i.ZERO) -> Array:
	return [
		isolevel,
		amplitude,
		frequency,
		persistence,
		lacunarity,
		noise_scale,
		octaves as float,
		world_chunk_count.x * CHUNK_VOXEL_COUNT as float,
		world_chunk_count.y * CHUNK_VOXEL_COUNT as float,
		world_chunk_count.z * CHUNK_VOXEL_COUNT as float,
		coord.x * CHUNK_VOXEL_COUNT as float,
		coord.y * CHUNK_VOXEL_COUNT as float,
		VOXEL_SIZE_PHYSICAL,
	]

 ## Currently unused...
func cleanup_compute() -> void:
	rendering_device.free_rid(params_buffer)
	rendering_device.free_rid(counter_buffer)
	rendering_device.free_rid(triangle_buffer)
	rendering_device.free_rid(buffer_set)
	rendering_device.free_rid(pipeline)
