extends Node

const MAX_HEALTH: float = 100.0
const MAX_REWIND_STAMINA: float = 100

var player_health: float = MAX_HEALTH
var player_rewind_stamina: float = 0

func update_player_health(delta: float) -> void:
	player_health = clampf(player_health + delta, 0.0, MAX_HEALTH)
	
	if player_health == 0.0:
		get_tree().call_group("game_over", "game_over")
		get_tree().paused = true
		
func update_player_rewind_stamina(delta: float) -> void:
	player_rewind_stamina = clampf(player_rewind_stamina + delta, 0.0, MAX_REWIND_STAMINA)
	
	if player_health == 0.0:
		get_tree().call_group("game_over", "game_over")
		get_tree().paused = true

func can_rewind() -> bool:
	return player_rewind_stamina == MAX_REWIND_STAMINA

func restart() -> void:
	player_health = MAX_HEALTH
	player_rewind_stamina = 0
	
	get_tree().paused = false
	get_tree().reload_current_scene()
