class_name WorldData
extends Resource

@export var chunk_atlas: Array[ChunkData]

## === Sizes ===
@export var world_chunk_count: Vector3i
@export var world_size_logical: Vector3i
@export var world_size_physical: Vector3
@export var chunk_size_logical: int
@export var chunk_size_physical: float
@export var voxel_size_physical: float

func _init(chunk_count: Vector3i, voxel_count: int, voxel_size: float) -> void:
	world_chunk_count = chunk_count
	chunk_size_logical = voxel_count
	voxel_size_physical = voxel_size
	
	world_size_logical = world_chunk_count * chunk_size_logical
	world_size_physical = world_size_logical * voxel_size_physical
	chunk_size_physical = chunk_size_logical * voxel_size_physical
	
	chunk_atlas.resize(world_chunk_count.x * world_chunk_count.y * world_chunk_count.z)


func get_chunk_for_marching_cubes(coord: Vector3i) -> PackedFloat32Array:
	## Look...this is a fucking mess...but I needed a way to interweave
	## neighboring chunk densities since I'm using marching cubes and it
	## requires "N+1". In this case the "+1" is part of its neighbors.
	## But it works!..I think...
	
	var current    = get_atlas_chunk(coord).voxel_values
	var z_face     = get_atlas_chunk(coord + Vector3i(0, 0, 1)).get_z_face()
	var x_face     = get_atlas_chunk(coord + Vector3i(1, 0, 0)).get_x_face()
	var xz_edge    = get_atlas_chunk(coord + Vector3i(1, 0, 1)).get_xz_edge()
	var y_face     = get_atlas_chunk(coord + Vector3i(0, 1, 0)).get_y_face()
	var yz_edge    = get_atlas_chunk(coord + Vector3i(0, 1, 1)).get_yz_edge()
	var xy_edge    = get_atlas_chunk(coord + Vector3i(1, 1, 0)).get_xy_edge()
	var xyz_corner = get_atlas_chunk(coord + Vector3i(1, 1, 1)).get_xyz_corner()
	
	var data: Array[float]= []
	data.resize((chunk_size_logical + 1) ** 3)
	var indices: Array[int] = []
	indices.resize(8)
	
	## a-g themselves have no meaning, idk what to name them.
	for a in range(chunk_size_logical):
		for b in range(chunk_size_logical):
			for c in range(chunk_size_logical):
				data[indices[0]] = current[indices[1]]
				indices[0] += 1
				indices[1] += 1
			data[indices[0]] = z_face[indices[2]]
			indices[0] += 1
			indices[2] += 1
		for d in range(chunk_size_logical):
			data[indices[0]] = x_face[indices[3]]
			indices[0] += 1
			indices[3] += 1
		data[indices[0]] = xz_edge[indices[4]]
		indices[0] += 1
		indices[4] += 1
	for e in range(chunk_size_logical):
		for f in range(chunk_size_logical):
			data[indices[0]] = y_face[indices[5]]
			indices[0] += 1
			indices[5] += 1
		data[indices[0]] = yz_edge[indices[6]]
		indices[0] += 1
		indices[6] += 1
	for g in range(chunk_size_logical):
		data[indices[0]] = xy_edge[indices[7]]
		indices[0] += 1
		indices[7] += 1
	data[indices[0]] = xyz_corner[0]
	
	return PackedFloat32Array(data)


func get_atlas_chunk(coord: Vector3i) -> ChunkData:
	return chunk_atlas[get_atlas_index(coord)]


func get_atlas_index(coord: Vector3i) -> int:
	coord.x %= world_chunk_count.x
	#coord.y %= chunk_count.y
	coord.z %= world_chunk_count.z
	return (coord.x) + (coord.y * world_chunk_count.x) + (coord.z * world_chunk_count.x * world_chunk_count.y)
