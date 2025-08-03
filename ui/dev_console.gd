extends PanelContainer

func _process(delta):
	$VBoxContainer/BossShardLabel.text = "Boss Shards: " + str(Global.boss_shards)

func _on_damage_boss_button_pressed():
	Global.update_boss_health(-(Global.max_boss_health/10.0))

func _on_damage_player_button_pressed():
	Global.update_player_health(-(Global.MAX_HEALTH/10.0))

func _on_add_shard_button_pressed():
	var rand_boss_name = str(randi() * 1000 + 1)
	Global.defeated_bosses[rand_boss_name] = false
	Global.defeat_boss(rand_boss_name)
