extends State

@export var duration:= 0.5
@export var height:= 1.1
@export_category("States")
@export var default_state: State

var direction: Vector2
var magnitude: float= 1.0
var time_remaining: float
func enter() -> void:
	user.set_height(height)
	direction = user.goal_direction
	magnitude = user.lateral_velocity.length() * 1.2
	time_remaining = duration


func exit() -> void:
	user.set_height()


func process_physics(delta: float) -> State:
	time_remaining -= delta
	if time_remaining <= 0 or not user.is_on_floor():
		return default_state
	
	user.lateral_velocity = direction * magnitude
	user.velocity.y -= user.gravity * delta
	
	return null
