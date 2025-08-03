extends CharacterBody2D

var player_inside = false
var dialogue = [
	"Welcome back! Did you collect any more shards from the three guardians this time? Oh, no worries! I'll be here when you get back, just like last time! Make sure to [R]ewind when your time meter reaches 100%, and give yourself [Space] with your dash! You'll get it eventually!"
]

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		get_tree().call_group("ui", "display_dialogue", dialogue[0])

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		$InteractLabel.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		$InteractLabel.visible = false
