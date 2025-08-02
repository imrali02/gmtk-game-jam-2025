extends Node2D

func _ready():
	Global.boss_name = "The Cat"

func _on_attack_timer_timeout():
	$AttackTimer.start()
	
	# Call launch_attack on the Chesire Cat
	if $"Chesire Cat" and not $"Chesire Cat".attack_in_progress:
		$"Chesire Cat".launch_attack()
