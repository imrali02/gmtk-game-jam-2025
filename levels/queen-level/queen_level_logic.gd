extends Node2D

func _ready():
	Global.boss_name = "The Queen"
	Global.boss_health = 100.0

func _on_attack_timer_timeout():
	$Queen.launch_attack()
	$AttackTimer.start()
