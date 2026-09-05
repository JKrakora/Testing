extends Node3D

const WORLD_CHUNK_COUNT:= Vector3i(10, 10, 10)
const CHUNK_VOXEL_COUNT:= 8 ## Must match the local_size_n of the accompanying compute shader.
const VOXEL_SIZE:= 1.0
const CHUNK_SCENE = preload("uid://db8xek20hcapq")

var rendering_device: RenderingDevice
var shader: RID
var pipeline: RID

var buffer_set: RID
var params_buffer: RID
const PARAMS_BINDING:= 0
var counter_buffer: RID
const COUNTER_BINDING:= 1
var counter_data_bytes
var triangle_buffer: RID
const TRIANGLE_BINDING:= 2
var triangle_data_bytes
var num_triangles: int

var thread
var queue: Array[Vector2i]

func _ready() -> void:
	setup_compute()
	
	## DEBUG START =============================================================
	for x in range(WORLD_CHUNK_COUNT.x):
		for z in range(WORLD_CHUNK_COUNT.z):
			queue.append(Vector2i(x, z))
	
	await get_tree().create_timer(3.0).timeout
	run_compute()
	## DEBUG END ===============================================================


func setup_compute() -> void:
	rendering_device = RenderingServer.create_local_rendering_device()
	var shader_file: RDShaderFile= load("uid://1kw6ndjpict4")
	var shader_spirv: RDShaderSPIRV= shader_file.get_spirv()
	shader = rendering_device.shader_create_from_spirv(shader_spirv)
	
	var params_bytes = PackedFloat32Array(get_params()).to_byte_array()
	params_buffer = rendering_device.storage_buffer_create(params_bytes.size(), params_bytes)
	var params_uniform:= RDUniform.new()
	params_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	params_uniform.binding = PARAMS_BINDING
	params_uniform.add_id(params_buffer)
	
	var counter_array = [0]
	var counter_bytes = PackedInt32Array(counter_array).to_byte_array()
	counter_buffer = rendering_device.storage_buffer_create(counter_bytes.size(), counter_bytes)
	var counter_uniform:= RDUniform.new()
	counter_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	counter_uniform.binding = COUNTER_BINDING
	counter_uniform.add_id(counter_buffer)
	
	const MAX_TRIS_PER_VOXEL:= 5 ## Per Marching Cube Algorithm.
	const BYTES_PER_TRIANGLE:= 48 ## float32 are 4 bytes, Tri's have 4 vec3's: 4 * 4 * 3 = 48. (But don't vec3s return as vec4s???)
	var max_triangles:= MAX_TRIS_PER_VOXEL * ((CHUNK_VOXEL_COUNT + 1) ** 3) * WORLD_CHUNK_COUNT.y
	var max_bytes:= BYTES_PER_TRIANGLE * max_triangles
	triangle_buffer = rendering_device.storage_buffer_create(max_bytes)
	var triangle_uniform = RDUniform.new()
	triangle_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	triangle_uniform.binding = TRIANGLE_BINDING
	triangle_uniform.add_id(triangle_buffer)
	
	var buffers = [params_uniform, counter_uniform, triangle_uniform]
	buffer_set = rendering_device.uniform_set_create(buffers, shader, 0)
	pipeline = rendering_device.compute_pipeline_create(shader)


func run_compute() -> void:
	var params_bytes = PackedFloat32Array(get_params(queue[0])).to_byte_array()
	rendering_device.buffer_update(params_buffer, 0, params_bytes.size(), params_bytes)
	
	var counter = [0]
	var counter_bytes = PackedInt32Array(counter).to_byte_array()
	rendering_device.buffer_update(counter_buffer, 0, counter_bytes.size(), counter_bytes)
	
	var compute_list = rendering_device.compute_list_begin()
	rendering_device.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rendering_device.compute_list_bind_uniform_set(compute_list, buffer_set, 0)
	rendering_device.compute_list_dispatch(compute_list, 1, WORLD_CHUNK_COUNT.y, 1)
	rendering_device.compute_list_end()
	
	rendering_device.submit()
	## Wait? Seems fine on my PC without it...
	rendering_device.sync()
	
	counter_data_bytes = rendering_device.buffer_get_data(counter_buffer)
	triangle_data_bytes = rendering_device.buffer_get_data(triangle_buffer)
	num_triangles = counter_data_bytes.to_int32_array()[0]
	
	thread = Thread.new()
	thread.start(create_mesh.bind(triangle_data_bytes.to_float32_array()))


func create_mesh(output_data: Array) -> void:
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
		
		var pos_a = Vector3(output_data[index + 0], output_data[index + 1], output_data[index + 2])
		var pos_b = Vector3(output_data[index + 4], output_data[index + 5], output_data[index + 6])
		var pos_c = Vector3(output_data[index + 8], output_data[index + 9], output_data[index + 10])
		vertices[tri_index * 3 + 0] = pos_a
		vertices[tri_index * 3 + 1] = pos_b
		vertices[tri_index * 3 + 2] = pos_c
		
		var norm = Vector3(output_data[index + 12], output_data[index + 13], output_data[index + 14])
		normals[tri_index * 3 + 0] = norm
		normals[tri_index * 3 + 1] = norm
		normals[tri_index * 3 + 2] = norm
	
	print("Num Tris: %s, FPS: %s" % [num_triangles, Engine.get_frames_per_second()])
	if vertices.size() > 0:
		var mesh_data = []
		mesh_data.resize(Mesh.ARRAY_MAX)
		mesh_data[Mesh.ARRAY_VERTEX] = vertices
		mesh_data[Mesh.ARRAY_NORMAL] = normals
		
		var array_mesh = ArrayMesh.new()
		array_mesh.clear_surfaces()
		array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
		add_chunk.call_deferred(array_mesh)


func add_chunk(array_mesh: ArrayMesh) -> void:
	thread.wait_to_finish()
	var chunk = CHUNK_SCENE.instantiate()
	chunk.mesh = array_mesh
	chunk.position = Vector3(queue[0].x, 0, queue[0].y) * CHUNK_VOXEL_COUNT * VOXEL_SIZE
	queue.pop_front()
	
	add_child.call_deferred(chunk)
	
	if queue.size() > 0:
		run_compute()


func get_params(coord:= Vector2i.ZERO) -> Array:
	return [
		0.0, # isolevel
		(WORLD_CHUNK_COUNT.x * CHUNK_VOXEL_COUNT) as float,
		(WORLD_CHUNK_COUNT.x * CHUNK_VOXEL_COUNT) as float,
		(WORLD_CHUNK_COUNT.x * CHUNK_VOXEL_COUNT) as float,
		(coord.x * CHUNK_VOXEL_COUNT) as float,
		0.0,
		(coord.y * CHUNK_VOXEL_COUNT) as float,
		VOXEL_SIZE,
		2.0 # noise scale
	]
