class_name Chunk
extends Node3D

var _data: ChunkData

func set_data(data: ChunkData, chunk_voxel_count: int) -> void:
	_data = data
	_data.edge_voxel_count = chunk_voxel_count


func set_data_raw(data: Array[float], chunk_voxel_count: int) -> void:
	_data = ChunkData.new()
	_data.voxel_values = data
	_data.edge_voxel_count = chunk_voxel_count
