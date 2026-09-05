extends State

@export var grounded_acceleration:= 50.0
@export var aerial_acceleration:= 10.0
@export var aerial_deceleration:= 2.0
@export_category("States")
@export var crouch_state: State
@export var jump_state: State
@export var mantle_state: State
@export var slide_state: State
@export var sprint_state: State
@export var vault_state: State

func exit() -> void:
	user.was_sprinting = false


var can_double_jump: bool
func process_physics(delta: float) -> State:
	user.was_sprinting = false
	
	if Input.is_action_just_pressed("jump"):
		if vault_state and vault_state.can_vault():
			return vault_state
		elif mantle_state and mantle_state.can_mantle():
			return mantle_state
		return jump_state
	if Input.is_action_just_pressed("sprint") and user.is_on_floor():
		return sprint_state
	if Input.is_action_just_pressed("crouch"):
		return crouch_state
	
	var goal_velocity = user.goal_direction * user.get_velocity_magnitude()
	if user.is_on_floor():
		user.lateral_velocity = user.lateral_velocity.move_toward(
				goal_velocity, 
				grounded_acceleration * delta
		)
	else:
		user.lateral_velocity = user.lateral_velocity.move_toward(
				goal_velocity, 
				(aerial_acceleration if goal_velocity else aerial_deceleration) * delta
		)
		user.velocity.y -= user.gravity * delta
	
	return null
