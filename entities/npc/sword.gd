extends CharacterBody2D

var SPEED = 4

var randomnum
var end

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
	
func _physics_process(delta):
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
		
