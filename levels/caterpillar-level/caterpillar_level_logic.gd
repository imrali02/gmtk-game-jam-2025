extends Node2D

func _ready():
	Global.boss_name = "The Caterpillar"

func _on_attack_timer_timeout():
	$Caterpillar.launch_attack()
	$AttackTimer.start()
