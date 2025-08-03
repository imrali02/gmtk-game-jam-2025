extends CharacterBody2D
class_name Player

var speed = 600.0
var acceleration: float = 10.0
var friction: float = 8.0
var direction: Vector2 = Vector2.ZERO

@onready var sprite

var dash_speed: float = 1200.0
var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("player")
	sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rewind") and Global.can_rewind():
		get_tree().call_group("rewindable", "rewind")
	if Input.is_action_just_released("rewind"):
		get_tree().call_group("rewindable", "resume")
		
	if $Rewinder.rewinding:
		Global.update_player_rewind_stamina(-Global.MAX_REWIND_STAMINA * 2 * delta / $Rewinder.replay_duration)
		return
		
	Global.update_player_rewind_stamina(Global.MAX_REWIND_STAMINA * 0.5 * delta / $Rewinder.replay_duration)
	
	if Input.is_action_pressed("ui_right"):
		sprite.play("walk_right")
		
	if Input.is_action_pressed("ui_left"):
		sprite.play("walk_left")
		
	if Input.is_action_pressed("ui_up"):
		sprite.play("walk_backwards")
		
	if Input.is_action_pressed("ui_down"):
		sprite.play("walk_forwards")
	
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
		if Input.is_action_pressed("ui_right"):
			sprite.play("dash_right")
		
		if Input.is_action_pressed("ui_left"):
			sprite.play("dash_left")
		velocity = lerp(velocity, direction * dash_speed, (dash_speed / 4) * delta)

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	$Rewinder.handle_rewind()

func _on_dash_cooldown_timer_timeout():
	is_dashing = false
	can_dash = true

func take_damage(damage: float) -> void:
	Global.update_player_health(-damage)
	
	sprite.modulate = Color(1, 0, 0)  # Red tint
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)  # Reset to normal
