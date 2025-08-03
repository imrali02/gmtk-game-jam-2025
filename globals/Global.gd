extends Node

const MAX_HEALTH: float = 100.0
const MAX_REWIND_STAMINA: float = 100

const MAIN_MENU_SCENE: String = "res://levels/main.tscn"
const LOBBY_SCENE: String = "res://levels/lobby.tscn"
const CHESIRE_SCENE: String = "res://levels/chesire-level/chesire_level.tscn"
const QUEEN_SCENE: String = "res://levels/queen-level/queen_level.tscn"
const HATTER_SCENE: String = "res://levels/hatter_level.tscn"
const CATERPILLER_SCENE: String = "res://levels/caterpillar-level/caterpillar_level.tscn"
const VICTORY_SCENE: String = "res://ui/victory_ui.tscn"

var player_health: float = MAX_HEALTH
var player_rewind_stamina: float = 0.0
var player_deaths: int = 0
var boss_name: String = "Racoonie, Robber of Rubbish"
var max_boss_health: float = 500.0
var boss_health: float = max_boss_health

var boss_shards = 0
var defeated_bosses = {
	"chesire" : false,
	"caterpillar" : false,
	"queen" : false
}

func update_player_health(delta: float) -> void:
	player_health = clampf(player_health + delta, 0.0, MAX_HEALTH)
	
	if player_health == 0.0:
		get_tree().call_group("game_over", "game_over")
		get_tree().paused = true
		
func update_player_rewind_stamina(delta: float) -> void:
	player_rewind_stamina = clampf(player_rewind_stamina + delta, 0.0, MAX_REWIND_STAMINA)
	
	if player_health == 0.0:
		player_deaths += 1
		get_tree().call_group("game_over", "game_over")
		get_tree().paused = true

func defeat_boss(boss: String) -> void:
	if boss not in defeated_bosses or defeated_bosses[boss]:
		return
	
	defeated_bosses[boss] = true
	boss_shards += 1

func can_rewind() -> bool:
	return player_rewind_stamina == MAX_REWIND_STAMINA
	
func update_boss_health(delta: float) -> void:
	boss_health = clampf(boss_health + delta, 0.0, max_boss_health)
	
	if boss_health == 0.0:
		get_tree().call_group("game_over", "on_boss_defeated")
		get_tree().paused = true

func restart_game() -> void:
	reset_player()
	boss_shards = 0
	defeated_bosses = {
		"chesire" : false,
		"caterpillar" : false,
		"queen" : false
	}
	
	get_tree().paused = false
	get_tree().call_group("scene_changer", "fade_out_and_change_scene", MAIN_MENU_SCENE)

func reset_player() -> void:
	player_health = MAX_HEALTH
	player_rewind_stamina = 0
