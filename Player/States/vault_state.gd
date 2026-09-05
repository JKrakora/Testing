extends State

@export var duration:= 0.2
@export var tween_transition_type:= Tween.TRANS_SINE
@export var tween_ease_type:= Tween.EASE_IN_OUT
@export_category("Check Settings")
@export var height_check: RayCast3D
@export var height_check_relative_height: float= -0.25: ## Relative to Camera.position
	set(height):
		height_check_relative_height = height
		if not is_node_ready():
			await ready
		height_check.position.y = height_check_relative_height
@export var height_check_relative_distance: float= 1.75: ## Relative to Camera.position
	set(distance):
		height_check_relative_distance = distance
		if not is_node_ready():
			await ready
		height_check.target_position.z = -height_check_relative_distance
		depth_check.position.z = -height_check_relative_distance
@export var depth_check: RayCast3D
@export var depth_check_relative_height: float= -0.75: ## Relative to Camera.position
	set(height):
		depth_check_relative_height = height
		if not is_node_ready():
			await ready
		depth_check.target_position.y = depth_check_relative_height - height_check_relative_height
@export_category("States")
@export var default_state: State
@export var sprint_state: State

func _ready() -> void:
	height_check_relative_height = height_check_relative_height
	height_check_relative_distance = height_check_relative_distance
	depth_check_relative_height = depth_check_relative_height


var tween
func enter() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(
			user,
			"global_position",
			_get_goal_position(),
			duration
	).set_trans(tween_transition_type).set_ease(tween_ease_type)


func exit() -> void:
	pass#user.velocity = Vector3.ZERO


func process_physics(_delta: float) -> State:
	if tween.get_total_elapsed_time() >= duration:
		return sprint_state if user.was_sprinting else default_state
	return null


func can_vault() -> bool:
	height_check.force_raycast_update()
	depth_check.force_raycast_update()
	return height_check.is_colliding() and not depth_check.is_colliding()


func _get_goal_position() -> Vector3:
	return Vector3(depth_check.global_position.x, user.position.y, depth_check.global_position.z)
