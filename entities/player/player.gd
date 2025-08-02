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

func _ready():
	add_to_group("player")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rewind"):
		get_tree().call_group("rewindable", "rewind")
	if Input.is_action_just_released("rewind"):
		get_tree().call_group("rewindable", "resume")
		
	if $Rewinder.rewinding:
		return
		
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	
	if direction.abs() > Vector2.ZERO and not is_dashing:
		velocity = lerp(velocity, direction * speed, acceleration * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)

	if direction.abs() > Vector2.ZERO and Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false
		$DashCooldownTimer.start()
		velocity = lerp(velocity, direction * dash_speed, (dash_speed / 4) * delta)

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	$Rewinder.handle_rewind()

func _on_dash_cooldown_timer_timeout():
	is_dashing = false
	can_dash = true

func take_damage(damage: float) -> void:
	Global.update_player_health(-damage)
	
	$Sprite2D.modulate = Color(1, 0, 0)  # Red tint
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color(1, 1, 1)  # Reset to normal
