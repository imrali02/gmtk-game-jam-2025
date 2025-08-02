extends Node2D

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func _on_attack_timer_timeout():
	$Queen.launch_attack()
	$AttackTimer.start()
