extends Node3D


## === World/Stack/Chunk/Voxel ===
@export var world_chunk_count:= Vector3i(50, 10, 50)
var world_size_logical: Vector3i

@export var chunk_voxel_count: int= 8
var chunk_atlas: Array[ChunkData]
var active_chunks: Dictionary[Vector3i, Chunk]

@export var voxel_size_physical: float= 1.0

func _ready() -> void:
	_fill_atlas()


func _fill_atlas() -> void:
	var noise = Noise4D.new()
	## setup noise params here
	
	chunk_atlas.resize(world_chunk_count.x * world_chunk_count.y * world_chunk_count.z)
	world_size_logical = world_chunk_count * chunk_voxel_count
	
	for cx in range(world_chunk_count.x):
		for cy in range(world_chunk_count.y):
			for cz in range(world_chunk_count.z):
				var chunk_coord:= Vector3i(cx, cy, cz)
				var chunk_offset:= chunk_coord * chunk_voxel_count
				var data = ChunkData.new()
				
				var densities: Array[float] = []
				densities.resize(chunk_voxel_count ** 3)
				var index = 0
				for x in range(chunk_voxel_count):
					for y in range(chunk_voxel_count):
						for z in range(chunk_voxel_count):
							var voxel_coord = Vector3i(x, y, z) + chunk_offset
							var theta_x = TAU * voxel_coord.x / world_size_logical.x
							var theta_z = TAU * voxel_coord.z / world_size_logical.z
							var torus_coord = Vector4(
								cos(theta_x),
								sin(theta_x),
								cos(theta_z),
								sin(theta_z),
							) * 50.0
							
							var terrain_value = noise.get_noise_4dv(torus_coord)
							terrain_value -= (float(voxel_coord.y) / world_size_logical.y) * 2.0 - 1.0
							
							## Other Noise logic here
							
							densities[index] = terrain_value
							index += 1
				data.voxel_densities = densities
				data.edge_voxel_count = chunk_voxel_count
				chunk_atlas[get_atlas_index(chunk_coord)] = data


func get_chunk_data_for_meshing(coord: Vector3i) -> PackedFloat32Array:
	var data = []
	data.resize((chunk_voxel_count + 1) ** 3)
	
	var current = get_atlas_chunk(coord) ## of (0, 0, 0)
	var z_face = current.get_z_face() ## of (0, 0, 1)
	var x_face = current.get_x_face() ## of (1, 0, 0)
	var xz_edge = current.get_xz_edge() ## of (1, 0, 1)
	
	var y_face = current.get_y_face() ## of (0, 1, 0)
	var yz_edge = current.get_yz_edge() ## of (0, 1, 1)
	
	var xy_edge = current.get_xy_edge() ## of (1, 1, 0)
	var xyz_corner = current.get_xyz_corner() ## of (1, 1, 1)
	
	var indices: Array[int] = []
	indices.resize(8)
	
	## Look...this is a fucking mess...but I needed a way to interweave
	## neighboring chunk densities since I'm using marching cubes and it 
	## requires "N + 1". In this case the "+ 1" is part of neighboring 
	## chunks. They're labeled and all, but "a-g" don't mean anything and
	## the colors only make sense with my schizo drawings. But it works.
	for a in range(chunk_voxel_count):
		for b in range(chunk_voxel_count):
			for c in range(chunk_voxel_count):
				data[indices[0]] = current.voxel_densities[indices[1]] ## Red
				indices[0] += 1
				indices[1] += 1
			data[indices[0]] = z_face[indices[2]]  ## Orange
			indices[0] += 1
			indices[2] += 1
		for d in range(chunk_voxel_count):
			data[indices[0]] = x_face[indices[3]] ## Yellow
			indices[0] += 1
			indices[3] += 1
		data[indices[0]] = xz_edge[indices[4]] ## Lime
		indices[0] += 1
		indices[4] += 1
	for e in range(chunk_voxel_count):
		for f in range(chunk_voxel_count):
			data[indices[0]] = y_face[indices[5]] ## Green
			indices[0] += 1
			indices[5] += 1
		data[indices[0]] = yz_edge[indices[6]] ## Blue
		indices[0] += 1
		indices[6] += 1
	for g in range(chunk_voxel_count):
		data[indices[0]] = xy_edge[indices[7]] ## Indigo
		indices[0] += 1
		indices[7] += 1
	data[indices[0]] = xyz_corner[0] ## Purple
	
	return PackedFloat32Array(data)


func get_atlas_chunk(coord: Vector3i) -> ChunkData:
	return chunk_atlas[get_atlas_index(get_atlas_coord(coord))]


func get_atlas_coord(coord: Vector3i) -> Vector3i:
	return Vector3i(
		coord.x % world_chunk_count.x,
		coord.y % world_chunk_count.y,
		coord.z % world_chunk_count.z,
	)


func get_atlas_index(atlas_coord: Vector3i) -> int:
	return atlas_coord.x + (atlas_coord.y * world_chunk_count.x) + (atlas_coord.z * world_chunk_count.x * world_chunk_count.y)
