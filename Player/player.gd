class_name Player
extends CharacterBody3D

@export var default_speed = 7.0
@export_category("Components")
@export var movement_machine: StateMachine
@export var camera: Camera3D
@export var collider: CollisionShape3D
@export var debug_mesh: MeshInstance3D

@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Referenced by "movement_machine" Components
var goal_direction: Vector2
var time_in_air: float
var was_sprinting: bool
var lateral_velocity: Vector2:
	set(vel):
		velocity.x = vel.x
		velocity.z = vel.y
	get: 
		return Vector2(velocity.x, velocity.z)

func _ready() -> void:
	if movement_machine: 
		movement_machine.init(self)


func _unhandled_input(event: InputEvent) -> void:
	movement_machine.process_input(event)


func _physics_process(delta: float) -> void:
	if is_on_floor():
		time_in_air = 0
	else:
		time_in_air += delta
	
	goal_direction = Input.get_vector(
			"move_left", 
			"move_right", 
			"move_forward", 
			"move_backward"
	).rotated(-camera.rotation.y)
	movement_machine.process_physics(delta)
	
	move_and_slide()


func _process(delta: float) -> void:
	movement_machine.process_frame(delta)


func get_velocity_magnitude() -> float:
	return default_speed


func set_height(to: float= 2.0) -> void:
	# Debug Mesh
	if debug_mesh:
		debug_mesh.mesh.height = to
	
	# Collision Shape
	if collider:
		collider.position.y = to / 2.0
		collider.shape.height = to
	
	# Camera
	if camera:
		var pos = collider.position.y + 0.5
		if camera.target:
			camera.target.position.y = pos
		else:
			camera.position.y = pos


func get_camera_direction() -> Vector3:
	return -camera.transform.basis.z
