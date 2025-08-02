extends Node2D

func _on_attack_timer_timeout():
	$Queen.launch_attack()
	$AttackTimer.start()
