extends CanvasLayer

func _ready():
	get_tree().paused = false

func _on_main_menu_button_pressed():
	Global.restart_game()
