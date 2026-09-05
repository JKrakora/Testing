extends State

@export var grounded_acceleration:= 75.0
@export var aerial_acceleratino:= 40.0
@export var speed_mult:= 1.75
@export_category("States")
@export var default_state: State
@export var jump_state: State
@export var mantle_state: State
@export var slide_state: State
@export var vault_state: State

func exit() -> void:
	user.was_sprinting = true


func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		if vault_state and vault_state.can_vault():
			return vault_state
		elif mantle_state and mantle_state.can_mantle():
			return mantle_state
		return jump_state
	elif Input.is_action_just_pressed("sprint") or user.is_on_wall() or not user.goal_direction:
		return default_state
	elif Input.is_action_just_pressed("crouch"):
		return slide_state
	
	var goal_velocity = user.goal_direction * user.get_velocity_magnitude()
	if user.is_on_floor():
		user.lateral_velocity = user.lateral_velocity.move_toward(
				goal_velocity * speed_mult, 
				grounded_acceleration * delta
		)
	else:
		user.lateral_velocity = user.lateral_velocity.move_toward(
				goal_velocity * speed_mult, 
				aerial_acceleratino * delta
		)
		user.velocity.y -= user.gravity * delta
	
	return null
