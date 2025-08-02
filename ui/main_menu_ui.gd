extends CanvasLayer

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://levels/lobby.tscn")
