extends Control

func toggle_pause() -> void:
	self.visible = !self.visible
	get_tree().paused = !get_tree().paused

func _on_resume_button_pressed():
	toggle_pause()

func _on_lobby_button_pressed():
	toggle_pause()
	get_tree().call_group("scene_changer", "fade_out_and_change_scene", Global.LOBBY_SCENE)
