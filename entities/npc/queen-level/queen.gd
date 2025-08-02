extends CharacterBody2D

@export var player: CharacterBody2D

var SPEED = 200

var rng
var randomnum

var head_scene
var sword_scene
var soldier_scene

enum {
	ROAM,
	STAY,
}

var state = STAY

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	
	head_scene = preload("res://entities/npc/queen-level/homing_head.tscn")
	sword_scene = preload("res://entities/npc/queen-level/sword.tscn")
	soldier_scene = preload("res://entities/npc/queen-level/card_soldier.tscn")

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
	var attack = rng.randi() % 4
	print(attack)
	if attack == 0:
		# Guillotine attack
		var head = head_scene.instantiate()
		head.player = self.player
		add_child(head)
	elif attack == 1:
		# Marching cards
		var missing = rng.randi() % 4
		var direction_select = rng.randf()
		for i in 4:
			if i != missing:
				var soldier = soldier_scene.instantiate()
				if direction_select < 0.5:
					soldier.SPEED = -500
					soldier.position += Vector2(450, 50 + 100 * (i + 1))
				else:
					soldier.position += Vector2(-450, 50 + 100 * (i + 1))
				add_child(soldier)
		pass
	elif attack == 2:
		# Sword
		var sword = sword_scene.instantiate()
		add_child(sword)
		pass
	else:
		pass
