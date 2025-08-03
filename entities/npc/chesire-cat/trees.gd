extends AnimatableBody2D

var damage = 15
var attack_duration = 1.5
var retract_duration = 1.0
var is_attacking = false
var original_position
var extension_distance = 150
var player

func _ready():
	add_to_group("rewindable")
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	
	# Store original position of tree
	original_position = self.position

func attack():
	if is_attacking:
		return
		
	is_attacking = true
	
	# Extend branches
	var tween = create_tween()
	tween.tween_property(self, "position", 0.0, 3.0)
	
	await get_tree().create_timer(attack_duration + 1.0).timeout
	retract()

func retract():
	var tween = create_tween()
	tween.tween_property(self, "position", original_position, 3.0)
	
	await tween.finished
	is_attacking = false

func _on_body_entered(body):
	if body.is_in_group("player") and is_attacking:
		player.take_damage(damage)

func rewind() -> void:
	set_physics_process(false)


func resume() -> void:
	set_physics_process(true)
