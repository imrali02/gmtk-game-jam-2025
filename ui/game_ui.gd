extends CanvasLayer

@export var health_bar: ProgressBar
@export var rewind_bar: ProgressBar
@export var rewind_label: Label

func _ready():
	rewind_label.visible = false
	$GameOverScreen.visible = false
	
	add_to_group("rewindable")
	add_to_group("game_over")

	update_ui()

func _process(delta: float) -> void:
	update_ui()
	
func update_ui() -> void:
	# May need to update with better UI
	health_bar.value = Global.player_health
	rewind_bar.value = Global.player_rewind_stamina
	
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
	$GameOverScreen.visible = true

func _on_restart_button_pressed():
	Global.restart()
