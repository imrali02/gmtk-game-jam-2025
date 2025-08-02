extends CharacterBody2D

var SPEED = 500
var start_x
var player_ref

func _ready():
	start_x = self.position.x
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]

func _physics_process(delta):
	move(delta)
	if abs(self.position.x - start_x) >= 1200:
		queue_free()

func move(delta):
	var direction = Vector2(1, 0) 
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_ref.take_damage(10.0)
