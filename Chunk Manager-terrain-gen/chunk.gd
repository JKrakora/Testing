class_name Chunk
extends MeshInstance3D

var data: ChunkData
var idle_time: float

func init(chunkdata: ChunkData) -> void:
	self.data = chunkdata
	if data: 
		set_array_mesh(data.arraymesh)


func set_array_mesh(array_mesh: ArrayMesh) -> void:
	mesh = array_mesh
