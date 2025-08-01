extends CharacterBody2D
class_name Player

var speed = 600.0
var acceleration: float = 10.0
var friction: float = 8.0
var direction: Vector2 = Vector2.ZERO

var dash_speed: float = 1200.0
var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: Vector2 = Vector2.ZERO

var replay_duration: float = 3.0
var rewinding: bool = false
var rewind_values = {
	"position": [],
	"velocity": []
}

func _ready():
	# Called when the node enters the scene tree
	add_to_group("player")
	add_to_group("rewindable")

func _on_ready():
	# Connected to the ready signal
	pass

func _process(delta: float) -> void:
	if rewinding:
		return
		
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	
	if direction.abs() > Vector2.ZERO and not is_dashing:
		velocity = lerp(velocity, direction * speed, acceleration * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)
		
		if velocity.abs() <= Vector2.ONE.abs() * speed:
			is_dashing = false
			can_dash = true
		
	if direction.abs() > Vector2.ZERO and Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false
		velocity = lerp(velocity, direction * dash_speed, (dash_speed / 4) * delta)

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if not rewinding:
		if replay_duration * Engine.physics_ticks_per_second == rewind_values["position"].size():
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
				
		rewind_values["position"].append(global_position)
		rewind_values["velocity"].append(velocity)
	else:
		compute_rewind(delta)
		
func compute_rewind(delta: float) -> void:
	rewind_values["position"].pop_back()
	var pos = rewind_values["position"].pop_back()
	
	if len(rewind_values["position"]) <= 1:
		resume()
		global_position = pos
		rewind_values["position"].clear()
		rewind_values["velocity"].clear()
		return
	
	global_position = pos

func rewind() -> void:
	rewinding = true
	$CollisionShape2D.set_deferred("disabled", true)
	
func resume() -> void:
	rewinding = false
	$CollisionShape2D.set_deferred("disabled", false)
