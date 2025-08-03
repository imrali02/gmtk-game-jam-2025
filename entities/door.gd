extends Area2D

var destination_scene: String 
var player_inside = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		$InteractLabel.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		$InteractLabel.visible = false

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		if destination_scene != "":
			get_tree().call_group("scene_changer", "fade_out_and_change_scene", destination_scene)
