extends Node2D

func _on_attack_timer_timeout():
	$Caterpillar.launch_attack()
	$AttackTimer.start()
