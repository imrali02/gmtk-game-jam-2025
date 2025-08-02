extends CharacterBody2D

@export var player : CharacterBody2D

var SPEED = 200
var health = 100
var max_health = 100

var rng
var randomnum

enum {
	HEAD_THROW_ATTACK,
	TREE_ATTACK,
	BITE_ATTACK,
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
	# Make the cat partially invisible
	modulate.a = 0.3
	
func bite_attack():
	attack_in_progress = true
	
	var invisible_cat_scene = load("res://entities/npc/chesire-cat/invisible-cat.tscn")
	var invisible_cat = invisible_cat_scene.instantiate()
	get_tree().current_scene.add_child(invisible_cat)
	
	invisible_cat.global_position = global_position
	
	# Get a random position on the stage for the bite attack
	var viewport_size = get_viewport_rect().size
	var target_position = Vector2(
		randf_range(100, viewport_size.x - 100),
		randf_range(100, viewport_size.y - 100)
	)
	
	invisible_cat.initialize(target_position, self)
	go_invisible()
	
	await get_tree().create_timer(3.0).timeout
	modulate.a = 1.0
	state = STAY
	attack_in_progress = false
	
func tree_attack():
	attack_in_progress = true
	var trees = get_tree().current_scene.get_node("Trees")
	var trees2 = get_tree().current_scene.get_node("Trees2")
	
	if trees and trees.has_method("attack"):
		trees.attack()
	
	if trees2 and trees2.has_method("attack"):
		trees2.attack()
	
	await get_tree().create_timer(4.0).timeout
	attack_in_progress = false
	state = STAY
	
func head_throw_attack():
	attack_in_progress = true

	var cat_head_scene = load("res://entities/npc/chesire-cat/cat-head.tscn")
	var cat_head = cat_head_scene.instantiate()
	get_tree().current_scene.add_child(cat_head)
	
	# Set initial position at cat's position
	cat_head.global_position = global_position
	
	# Find player position
	var player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
	var direction = Vector2.RIGHT
	
	direction = (player.global_position - global_position).normalized()
	
	cat_head.initialize(direction, self)
	
	# Make the cat's head invisible during the attack
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = Rect2(0, 300, 300, 300)
	
	# Return head to cat
	await get_tree().create_timer(3.0).timeout
	$Sprite2D.region_enabled = false  # Show full cat again
	attack_in_progress = false

func launch_attack():
	if attack_in_progress:
		return
		
	var attack = rng.randi_range(0, 2)
	print("Launching attack: " + str(attack))
	
	if attack == 0:
		print("head throw")
		state = HEAD_THROW_ATTACK
		head_throw_attack()
	elif attack == 1:
		print("trees")
		state = TREE_ATTACK
		tree_attack()
	elif attack == 2:
		print("bite")
		state = BITE_ATTACK
		bite_attack()

func rewind() -> void:
	set_physics_process(false)
	attack_in_progress = false
	modulate.a = 1.0
	$Sprite2D.region_enabled = false


func resume() -> void:
	set_physics_process(true)
	state = STAY
