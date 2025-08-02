extends CharacterBody2D

var is_heart
var face_up
var card_back = preload("res://assets/card_back_temp.png")
var spade_face = preload("res://assets/card_face_spade_temp.png")
var heart_face = preload("res://assets/card_face_heart_temp.png")
var player_ref

func _ready():
	face_up = false
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]
	
func _physics_process(delta):
	$CardRewinder.handle_rewind()
		

func flip():
	if face_up:
		face_up = false
		$Sprite2D2.texture = card_back
		if is_heart:
			$CollisionShape2D.set_deferred("disabled", true)
		else:
			$CollisionShape2D.set_deferred("disabled", false)
	else:
		face_up = true
		$CollisionShape2D.set_deferred("disabled", false)
		if is_heart:
			$Sprite2D2.texture = heart_face
		else:
			$Sprite2D2.texture = spade_face


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if face_up:
			player_ref.take_damage(20.0)
		else:
			if not is_heart:
				player_ref.take_damage(20.0)
