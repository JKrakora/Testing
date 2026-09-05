extends Node3D

@export var speed: float= 10.0
@export var rotation_speed: float= 0.05
var direction:= Vector3.FORWARD

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	direction = direction.rotated(Vector3.UP, rotation_speed * delta).normalized()
