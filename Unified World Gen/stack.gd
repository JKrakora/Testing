class_name Stack
extends Node3D

var idle_time: float
var _chunks: Array[ChunkData]

func build(chunks: Array[ChunkData]) -> void:
	_chunks = chunks
