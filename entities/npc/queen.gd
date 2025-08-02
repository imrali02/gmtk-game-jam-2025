extends CharacterBody2D

@export var player: CharacterBody2D

var SPEED = 200

var rng
var randomnum

var head_scene
var sword_scene

enum {
	ROAM,
	STAY,
}

var state = STAY

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	
	head_scene = preload("res://entities/npc/homing_head.tscn")
	sword_scene = preload("res://entities/npc/sword.tscn")

func _physics_process(delta):
	match state:
		ROAM:
			move(get_circle_position(randomnum), delta)
		STAY:
			pass

func move(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()
	
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40
	 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)

func launch_attack():
	# var attack = floor(rng.randf() * 4.0)
	var attack = 2.0
	print(attack)
	if attack == 0.0:
		# Guillotine attack
		var head = head_scene.instantiate()
		head.player = self.player
		add_child(head)
	elif attack == 1.0:
		# Marching cards
		pass
	elif attack == 2.0:
		# Sword
		var sword = sword_scene.instantiate()
		add_child(sword)
		pass
	else:
		pass
