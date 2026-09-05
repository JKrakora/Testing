extends State

@export var duration:= 0.35
@export var tween_transition_type:= Tween.TRANS_SINE
@export var tween_ease_type:= Tween.EASE_IN_OUT
@export_category("Check Settings")
@export var wall_check: RayCast3D
@export var wall_check_relative_height: float= 0.6: ## Relative to Camera.position
	set(height):
		wall_check_relative_height = height
		if not is_node_ready():
			await ready
		wall_check.position.y = wall_check_relative_height
@export var wall_check_relative_forward: float= 1.0: ## Relative to Camera.position
	set(distance):
		wall_check_relative_forward = distance
		if not is_node_ready():
			await ready
		wall_check.target_position.z = -wall_check_relative_forward
		floor_check.position.z = -wall_check_relative_forward
@export var floor_check: RayCast3D
@export var floor_check_relative_height: float= -0.6: ## Relative to Camera.position
	set(height):
		floor_check_relative_height = height
		if not is_node_ready():
			await ready
		floor_check.target_position.y = floor_check_relative_height - wall_check_relative_height
@export_category("States")
@export var default_state: State

func _ready() -> void:
	wall_check_relative_height = wall_check_relative_height
	wall_check_relative_forward = wall_check_relative_forward
	floor_check_relative_height = floor_check_relative_height


var tween
func enter() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(
			user, 
			"global_position",
			floor_check.get_collision_point(),
			duration
	).set_trans(tween_transition_type).set_ease(tween_ease_type)


func exit() -> void:
	user.velocity = Vector3.ZERO


func process_physics(_delta: float) -> State:
	if tween.get_total_elapsed_time() >= duration:
		return default_state
	return null


func can_mantle() -> bool:
	wall_check.force_raycast_update()
	floor_check.force_raycast_update()
	return not wall_check.is_colliding() and floor_check.is_colliding()
