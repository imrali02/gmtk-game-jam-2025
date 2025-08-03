extends Node2D

func _ready():
	Global.boss_name = "The Caterpillar"
	Global.max_boss_health = 500.0
	Global.boss_health = Global.max_boss_health
	
	$UI.enable_boss_ui()

func _on_attack_timer_timeout():
	$Caterpillar.launch_attack()
	$AttackTimer.start()
