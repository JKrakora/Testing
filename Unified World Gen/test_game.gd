extends Node

@onready var manager:= $"World Manager"

func _ready() -> void:
	generate_world()

const WORLD_CHUNK_COUNT:= Vector3i(1, 1, 1)
const CHUNK_VOXEL_COUNT:= 8
const VOXEL_SIZE:= 1.0
func generate_world() -> void:
	var noise = Noise4D.new()
	var world = WorldData.new(WORLD_CHUNK_COUNT, CHUNK_VOXEL_COUNT, VOXEL_SIZE)
	
	for cx in range(WORLD_CHUNK_COUNT.x):
		for cy in range(WORLD_CHUNK_COUNT.x):
			for cz in range(WORLD_CHUNK_COUNT.x):
				var chunk_coord:= Vector3i(cx, cy, cz)
				
				var data: Array[float]= []
				data.resize(CHUNK_VOXEL_COUNT ** 3)
				var index = 0
				for x in range(CHUNK_VOXEL_COUNT):
					for y in range(CHUNK_VOXEL_COUNT):
						for z in range(CHUNK_VOXEL_COUNT):
							var global_coord:= Vector3i(x, y, z) + (chunk_coord * CHUNK_VOXEL_COUNT)
							var theta_x = TAU * global_coord.x / (WORLD_CHUNK_COUNT.x * CHUNK_VOXEL_COUNT)
							var theta_z = TAU * global_coord.z / (WORLD_CHUNK_COUNT.z * CHUNK_VOXEL_COUNT)
							var torus_coord = Vector4(
								cos(theta_x),
								sin(theta_x),
								cos(theta_z),
								sin(theta_z),
							) * 50.0
							
							var value = noise.get_noise_4dv(torus_coord)
							value -= (float(global_coord.y) / (WORLD_CHUNK_COUNT.y)) * 2.0 - 1.0
							
							data[index] = value
							index += 1
				var chunk = ChunkData.new()
				chunk.voxel_values = data
				world.chunk_atlas[world.get_atlas_index(chunk_coord)] = chunk
	
	manager.world = world
