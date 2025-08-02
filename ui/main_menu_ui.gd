extends CanvasLayer

func _on_play_button_pressed():
	$Fader.fade_out_and_change_scene("res://levels/lobby.tscn")
