extends Node2D

func _ready():
	Global.boss_name = "The Queen"
	Global.max_boss_health = 100.0
	Global.boss_health = Global.max_boss_health
	
	$UI.enable_boss_ui()

func _on_attack_timer_timeout():
	$Queen.launch_attack()
	$AttackTimer.start()
