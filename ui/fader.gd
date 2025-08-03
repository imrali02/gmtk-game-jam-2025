extends Control

func _ready():
	add_to_group("scene_changer")

func fade_out_and_change_scene(path: String):
	self.visible = true
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	
	if is_inside_tree():
		get_tree().change_scene_to_file(path)
	else:
		print_debug("fader.gd: get_tree() failed")
