extends Node3D

@export var world_chunk_count:= Vector3i(1, 1, 1)
@export var chunk_voxel_count: int= 8
var world_size_logical: Vector3i

var chunk_atlas: Dictionary[Vector3i, ChunkData]

func _ready() -> void:
	_fill_atlas()


func _fill_atlas() -> void:
	var noise = Noise4D.new()
	
	world_size_logical = world_chunk_count * chunk_voxel_count
	
	for cx in range(world_chunk_count.x):
		for cy in range(world_chunk_count.y):
			for cz in range(world_chunk_count.z):
				var chunk = ChunkData.new()
				
				var data = []
				data.resize(chunk_voxel_count ** 3)
				var index = 0
				for x in range(chunk_voxel_count):
					for y in range(chunk_voxel_count):
						for z in range(chunk_voxel_count):
							var global_coord:= Vector3i(x, y, z) + (Vector3i(cx, cy, cz) * chunk_voxel_count)
							var theta_x = TAU * global_coord.x / world_size_logical.x
							var theta_z = TAU * global_coord.z / world_size_logical.z
							const RADII = 50.0
							var torus_coord = Vector4(cos(theta_x), sin(theta_x), cos(theta_z), sin(theta_z)) * RADII
							
							var terrain_value = noise.get_noise_4dv(torus_coord)
							terrain_value -= (float(global_coord.y) / world_size_logical.y) * 2.0 - 1.0
							
							data[index] = terrain_value
							index += 1
				chunk.voxel_values = data
				chunk_atlas[Vector3i(cx, cy, cx)] = chunk


func get_chunk_data(chunk_coord: Vector3i, skirted:= true) -> Array:
	if not skirted:
		return chunk_atlas[chunk_coord].voxel_values
	
	var values = []
	
	## The following is the order of indices for the marching cubes algorithm
	## A == Red, B = Orange, C = Yellow, D = Lime
	## (000): A = 0; loop(A, A + N-1);
	## (001): B = 0;
	## (000): A += N; loop(A, A + N-1);
	## (001): B += N;
	## (100): C = 0; loop(C, C + N-1);
	## (101): D = 0; 
	
	## A == Red, B = Orange, C = Yellow, D = Lime
	## (000): A += N; loop(A, A + N-1);
	## (001): B += N;
	## (000): A += N; loop(A, A + N-1);
	## (001): B += N;
	## (100): C += N^2; loop(C, C + N-1);
	## (101): D += N^2;
	
	## E == Green, F == Sky, G == Blue, H == Purple
	## (010): E = 0; loop(E, E + N-1);
	## (011): F = 0;
	## (010): E += N; loop(E, E + N-1);
	## (011): F += N;
	## (110): G = 0; loop(G, G + N-1);
	## (111): H = 0;
	
	
	return values
