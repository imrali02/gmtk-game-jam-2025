extends CharacterBody2D

var SPEED = 4

var randomnum
var end
var player_ref
var swinging = false

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	print(randomnum)
	
	if randomnum > 0.5:
		self.rotation = PI/2
		end = -PI/2
	else:
		self.rotation = -PI/2
		end = PI/2
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]
	
func _physics_process(delta):
	if not swinging:
		return
	
	var new_angle
	if end > 0:
		new_angle = self.transform.get_rotation() + delta * SPEED
	else:
		new_angle = self.transform.get_rotation() - delta * SPEED
		
	self.rotation = new_angle
	
	if end < 0 and self.rotation <= -PI/2:
		self.queue_free()
	elif end > 0 and self.rotation >= PI/2:
		self.queue_free()
		


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if not player_ref.get_node("Rewinder").rewinding:
			player_ref.take_damage(10.0)


func _on_timer_timeout():
	swinging = true
