extends PanelContainer

func _process(delta):
	$VBoxContainer/BossShardLabel.text = "Boss Shards: " + str(Global.boss_shards)

func _on_damage_boss_button_pressed():
	Global.update_boss_health(-(Global.max_boss_health/10.0))

func _on_damage_player_button_pressed():
	Global.update_player_health(-(Global.MAX_HEALTH/10.0))
