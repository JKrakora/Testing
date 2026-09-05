class_name Chunk
extends MeshInstance3D

var data: ChunkData
var idle_time_seconds: float

func init(given_data: ChunkData) -> void:
	data = given_data
	if data:
		set_array_mesh(data.mesh)

func set_array_mesh(array_mesh: ArrayMesh) -> void:
	mesh = array_mesh
