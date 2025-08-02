extends CharacterBody2D

var SPEED = 500
var start_x

func _ready():
	start_x = self.position.x

func _physics_process(delta):
	move(delta)
	if abs(self.position.x - start_x) >= 900:
		queue_free()

func move(delta):
	var direction = Vector2(1, 0) 
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()
