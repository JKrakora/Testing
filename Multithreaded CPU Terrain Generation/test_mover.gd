extends Node3D

@export var direction:= Vector3.FORWARD
@export var rotation_speed:= 0.05
@export var speed: float= 1.0

func _physics_process(delta: float) -> void:
	position += direction.normalized() * speed * delta
	direction = direction.rotated(Vector3.UP, rotation_speed * delta)
