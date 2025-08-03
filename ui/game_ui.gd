extends CanvasLayer

@export var player_health_bar: ProgressBar
@export var rewind_bar: ProgressBar
@export var rewind_label: Label

@export var boss_label: Label
@export var boss_health_bar: ProgressBar

func _ready():
	rewind_label.visible = false
	$DeathScreen.visible = false
	$PauseMenu.visible = false
	
	player_health_bar.max_value = Global.MAX_HEALTH
	
	add_to_group("rewindable")
	add_to_group("game_over")

	update_ui()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		$PauseMenu.toggle_pause()
	
	update_ui()
	
func update_ui() -> void:
	# May need to update with better UI
	player_health_bar.value = Global.player_health
	rewind_bar.value = Global.player_rewind_stamina
	
	boss_label.text = Global.boss_name
	boss_health_bar.value = Global.boss_health
	
	if rewind_bar.value == Global.MAX_REWIND_STAMINA:
		rewind_bar.modulate.a = 1.0
	else:
		rewind_bar.modulate.a = 0.3
	
func rewind() -> void:
	rewind_label.visible = true

func resume() -> void:
	rewind_label.visible = false
	
func game_over() -> void:
	update_ui()
	$DeathScreen.visible = true
	await get_tree().create_timer(2).timeout
	get_tree().call_group("scene_changer", "fade_out_and_change_scene", Global.LOBBY_SCENE)
	
func disable_boss_ui() -> void:
	boss_health_bar.visible = false
	boss_label.visible = false

func enable_boss_ui() -> void:
	boss_health_bar.visible = true
	boss_label.visible = true
	boss_health_bar.max_value = Global.max_boss_health
	
func on_boss_defeated() -> void:
	if Global.boss_name == "The Cat":
		Global.defeat_boss("chesire")
	elif Global.boss_name == "The Caterpillar":
		Global.defeat_boss("caterpillar")
	elif Global.boss_name == "The Queen":
		Global.defeat_boss("queen")
	
	update_ui()
	await get_tree().create_timer(2).timeout
	get_tree().call_group("scene_changer", "fade_out_and_change_scene", Global.LOBBY_SCENE)
