extends CharacterBody2D

@export var player : CharacterBody2D

var SPEED = 200
var health = 100
var max_health = 100

var rng
var randomnum

var pipe_scene
var smoke_cloud
var smoke_wave

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
	
	pipe_scene = preload("res://entities/npc/caterpillar/puff_pipe.tscn")
	smoke_wave = preload("res://entities/npc/caterpillar/smoke_wave.tscn")
	smoke_cloud = preload("res://entities/npc/caterpillar/smoke_cloud.tscn")
	
	# Add to rewindable group
	add_to_group("rewindable")
	add_to_group("boss")

func teleport_to_corner():
	# Get the corners of the map
	
	var map_size = get_viewport_rect().size
	
	var corners = [
		Vector2(450, 250),  # top left
		Vector2(map_size.x - 450, 250),  # top right
		Vector2(450, map_size.y - 250),  # bottom left
		Vector2(map_size.x - 450, map_size.y - 250)  # bottom right
	]
	
	# Choose a random corner of the map
	var corner_index = rng.randi_range(0, 3)
	var target_position = corners[corner_index]
	
	# Create smoke clouds at all corners
	for i in range(4):
		print("making a new cloud")
		var smoke_cloud = smoke_cloud.instantiate()
		smoke_cloud.position = corners[i]
		get_parent().add_child(smoke_cloud)
	
	global_position = target_position # Teleport to the chosen corner
	attack_in_progress = false
	state = STAY
	
func smoke_cloud_attack():
	attack_in_progress = true
	
	# Create a timer for teleportation delay
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.connect("timeout", teleport_to_corner)
	add_child(timer)
	timer.start()
	
func puff_pipe_attack():
	attack_in_progress = true
	
	# Create a smoke projectile aimed at player
	var pipe = pipe_scene.instantiate()
	pipe.position = global_position
	pipe.target = player.global_position
	get_parent().add_child(pipe)
	
	attack_in_progress = false
	state = STAY
	
func smoke_wave_attack():
	attack_in_progress = true
	
	# Create expanding smoke wave
	var wave_count = 3
	var wave_delay = 0.3
	
	for i in range(wave_count):
		var timer = Timer.new()
		timer.wait_time = wave_delay * i
		timer.one_shot = true
		timer.connect("timeout", create_smoke_wave.bind(i * 50))
		add_child(timer)
		timer.start()
	
	# End attack after all waves
	var end_timer = Timer.new()
	end_timer.wait_time = wave_delay * wave_count
	end_timer.one_shot = true
	end_timer.connect("timeout", func(): attack_in_progress = false; state = STAY)
	add_child(end_timer)
	end_timer.start()

func create_smoke_wave(radius):
	# Create a smoke cloud that expands outward
	var smoke_wave = smoke_wave.instantiate()
	var viewport_rect = get_viewport_rect().size
	var smoke_x = rng.randi_range(0, viewport_rect.x-500)
	var smoke_y = rng.randi_range(0, viewport_rect.y-400)
	smoke_wave.position = Vector2(smoke_x, smoke_y)
	smoke_wave.scale = Vector2(0.5, 0.5)
	smoke_wave.expanding = true
	smoke_wave.max_radius = radius + 100
	smoke_wave.damage_player = true
	get_parent().add_child(smoke_wave)

func launch_attack():
	var attack = rng.randi_range(0, 2)
	print("Launching attack: " + str(attack))
	
	if attack == 0:
		for i in range(3) :
			puff_pipe_attack()
	elif attack == 1:
		print("teleporting")
		smoke_cloud_attack()
	elif attack == 2:
		print("smoke wave incoming")
		smoke_wave_attack()
		
func take_damage(damage):
	Global.boss_health -= damage
