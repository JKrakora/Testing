extends State

@export var coyote_time:= 0.2
@export var double_jump_enabled:= true
@export var grounded_jump_speed:= 10.0
@export var aerial_jump_speed:= 9.0
@export var aerial_non_neutral_mult:= 0.75
@export var acceleration:= 10.0
@export var deceleration:= 2.0
@export var mario_jump_enabled:= true
@export var mario_jump_gravity_mult:= 0.75
@export_category("States")
@export var default_state: State
@export var sprint_state: State

var can_double_jump: bool
func enter() -> void:
	## Grounded Jump
	if user.is_on_floor() or user.time_in_air <= coyote_time:
		user.velocity.y = grounded_jump_speed
		can_double_jump = true
	## Aerial Jump
	elif double_jump_enabled and can_double_jump:
		user.velocity.y = aerial_jump_speed
		can_double_jump = false
		if user.goal_direction:
			user.lateral_velocity = user.goal_direction * maxf(
					user.lateral_velocity.length(), 
					user.get_velocity_magnitude() * aerial_non_neutral_mult
			)


func process_physics(delta: float) -> State:
	## Mario Jump: Reduce gravity while "Jump" is still held while travelling upwards.
	if mario_jump_enabled and not user.is_on_floor() and Input.is_action_pressed("jump") and user.velocity.y >= 0.0:
		var goal_velocity = user.goal_direction * user.get_velocity_magnitude()
		user.lateral_velocity = user.lateral_velocity.move_toward(
				goal_velocity, 
				(acceleration if goal_velocity else deceleration) * delta
		)
		user.velocity.y -= user.gravity * mario_jump_gravity_mult * delta
		return null
	return sprint_state if user.was_sprinting else default_state
