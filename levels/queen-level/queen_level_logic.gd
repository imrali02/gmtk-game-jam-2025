extends Node2D

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rewind"):
		rewind()
	elif Input.is_action_just_released("rewind"):
		resume()
			
func rewind() -> void:
	get_tree().call_group("rewindable", "rewind")
	
func resume() -> void:
	get_tree().call_group("rewindable", "resume")

func _on_attack_timer_timeout():
	$Queen.launch_attack()
	$AttackTimer.start()
