extends CharacterBody2D

var is_heart
var face_up
var card_back = preload("res://assets/card_back.png")
var spade_face = preload("res://assets/card_face_spade.png")
var heart_face = preload("res://assets/card_face_heart.png")

func _ready():
	face_up = false
	
func _physics_process(delta):
	$CardRewinder.handle_rewind()
		

func flip():
	if face_up:
		face_up = false
		$Sprite2D2.texture = card_back
	else:
		face_up = true
		if is_heart:
			$Sprite2D2.texture = heart_face
		else:
			$Sprite2D2.texture = spade_face
