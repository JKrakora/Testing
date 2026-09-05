extends State

@export var grounded_acceleration:= 60.0
@export var aerial_acceleration:= 2.0
@export var height:= 1.25
@export var speed_mult:= 0.4
@export_category("States")
@export var default_state: State
@export var jump_state: State
@export var mantle_state: State
@export var sprint_state: State
@export var vault_state: State

func enter() -> void:
	user.set_height(height)


func exit() -> void:
	user.set_height()


func process_physics(delta: float) -> State:
	if Input.is_action_just_released("crouch"):
		return default_state
	elif Input.is_action_just_pressed("sprint"):
		return sprint_state
	elif Input.is_action_just_pressed("jump"):
		if mantle_state and mantle_state.can_mantle():
			return mantle_state
		return jump_state
	
	var goal_velocity = user.goal_direction * user.get_velocity_magnitude()
	if user.is_on_floor():
		user.lateral_velocity = user.lateral_velocity.move_toward(
				goal_velocity * speed_mult, 
				grounded_acceleration * delta
		)
	else:
		user.lateral_velocity = user.lateral_velocity.move_toward(
				goal_velocity * speed_mult, 
				aerial_acceleration * delta
		)
		user.velocity.y -= user.gravity * delta
	
	return null
