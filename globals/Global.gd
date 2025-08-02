extends Node

const MAX_HEALTH: float = 100.0

var player_health: float = MAX_HEALTH

func update_player_health(delta: float) -> void:
	player_health = clampf(player_health + delta, 0.0, 100.0)
	
	if player_health == 0.0:
		get_tree().call_group("game_over", "game_over")
		get_tree().paused = true
		
func restart() -> void:
	player_health = MAX_HEALTH
	
	get_tree().paused = false
	get_tree().reload_current_scene()
