extends CharacterBody2D

@export var player : CharacterBody2D

var SPEED = 200
var health = 100
var max_health = 100

var rng
var randomnum

enum {
	SMOKE_CLOUD_ATTACK,
	PUFF_PIPE_ATTACK,
	SMOKE_WAVE_ATTACK,
	STAY,
}

var state = STAY

var attack_in_progress = false

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	
	# Add to rewindable group
	add_to_group("rewindable")

func go_invisible():
	pass
	
func bite_attack():
	attack_in_progress = true
	pass
	
func tree_attack():
	attack_in_progress = true
	pass
	
	attack_in_progress = false
	state = STAY
	
func head_throw_attack():
	attack_in_progress = true
	
	attack_in_progress = false
	pass

func throw_head(direction):
	pass

func launch_attack():
	var attack = rng.randi_range(0, 2)
	print("Launching attack: " + str(attack))
	
	if attack == 0:
		print("head throw")
		state = head_throw_attack()
	elif attack == 1:
		print("trees")
		state = tree_attack()
	elif attack == 2:
		print("bite")
		state = bite_attack()
