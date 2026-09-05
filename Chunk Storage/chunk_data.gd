class_name ChunkData
extends Resource

@export var edge_voxel_count: int
@export var voxel_densities: Array[float]

var _x_face: Array= []
var _y_face: Array= []
var _z_face: Array= []
var _xz_edge: Array= []
var _xy_edge: Array= []
var _yz_edge: Array= []
## _xyz_corner not needed, it's always [0].

func get_x_face() -> Array:
	if _x_face.is_empty():
		_x_face.resize(edge_voxel_count ** 2)
		var index = 0 
		for y in range(edge_voxel_count):
			for z in range(edge_voxel_count):
				_x_face[index] = edge_voxel_count ** 2 * y + z
				index += 1
	
	return _get_array(_x_face)


func get_y_face() -> Array:
	if _y_face.is_empty():
		_y_face.resize(edge_voxel_count ** 2)
		var index = 0
		for x in range(edge_voxel_count):
			for z in range(edge_voxel_count):
				_y_face[index] = x * edge_voxel_count + z 
				index += 1
	
	return _get_array(_y_face)


func get_z_face() -> Array:
	if _z_face.is_empty():
		_z_face.resize(edge_voxel_count ** 2)
		var index = 0
		for y in range(edge_voxel_count):
			for x in range(edge_voxel_count):
				_z_face[index] = (x * edge_voxel_count) + (edge_voxel_count ** 2 * y)
				index += 1
	
	return _get_array(_z_face)


func get_xz_edge() -> Array:
	if _xz_edge.is_empty():
		_xz_edge.resize(edge_voxel_count)
		var index = 0
		for y in range(edge_voxel_count):
			_xz_edge[index] = edge_voxel_count ** 2 * y
			index += 1
	
	return _get_array(_xz_edge)


func get_xy_edge() -> Array:
	if _xy_edge.is_empty():
		_xy_edge.resize(edge_voxel_count)
		var index = 0
		for z in range(edge_voxel_count):
			_xy_edge[index] = z
			index += 1
	
	return _get_array(_xy_edge)


func get_yz_edge() -> Array:
	if _yz_edge.is_empty():
		_yz_edge.resize(edge_voxel_count)
		var index = 0
		for x in range(edge_voxel_count):
			_yz_edge[index] = edge_voxel_count * x
			index += 1
	
	return _get_array(_yz_edge)


func get_xyz_corner() -> Array:
	return _get_array([0])


func _get_array(indices: Array) -> Array:
	var values = []
	values.resize(indices.size())
	for i in range(indices.size()):
		values[i] = voxel_densities[indices[i]]
	return values
