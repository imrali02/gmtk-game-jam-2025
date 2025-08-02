extends Node2D

func _ready():
	Global.boss_name = "The Cat"

func _on_attack_timer_timeout():
	$AttackTimer.start()
	pass
