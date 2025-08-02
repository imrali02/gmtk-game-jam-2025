extends Node2D

var lifetime = 3.0
var damage = 5
var damage_interval = 0.5
var expanding = false
var max_radius = 150
var expansion_speed = 100
var current_radius = 50
var damage_player = false

var damage_timer = null
var player_in_cloud = false
var player_ref = null

func _ready():
	# Create a timer to destroy the cloud after lifetime
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", queue_free)
	add_child(timer)
	timer.start()
	
	# Add to rewindable group
	add_to_group("rewindable")
	
	# Create a sprite for the cloud
	var sprite = Sprite2D.new()
	sprite.scale = Vector2(1, 1)
	# You'll need to set the texture to your smoke texture
	# sprite.texture = preload("res://path/to/smoke_texture.png")
	add_child(sprite)
	
	# Create a collision shape for detecting player
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = current_radius
	collision.shape = shape
	area.add_child(collision)
	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)
	add_child(area)
	
	# Set up damage timer
	damage_timer = Timer.new()
	damage_timer.wait_time = damage_interval
	damage_timer.connect("timeout", _on_damage_timer_timeout)
	add_child(damage_timer)

	# Find player reference
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]

func _physics_process(delta):
	# Handle expansion for smoke wave
	if expanding:
		current_radius += expansion_speed * delta
		
		# Update collision shape radius
		var area = get_node_or_null("Area2D")
		if area and area.get_child(0) is CollisionShape2D:
			var collision = area.get_child(0)
			if collision.shape is CircleShape2D:
				collision.shape.radius = current_radius
		
		# Update sprite scale
		var sprite = get_node_or_null("Sprite2D")
		if sprite:
			var scale_factor = current_radius / 50.0  # Assuming 50 is the base radius
			sprite.scale = Vector2(scale_factor, scale_factor)
		
		# Destroy if reached max radius
		if current_radius >= max_radius:
			expanding = false

func _on_body_entered(body):
	if body.is_in_group("player") and damage_player:
		player_in_cloud = true
		damage_timer.start()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_cloud = false
		damage_timer.stop()

func _on_damage_timer_timeout():
	if player_in_cloud and player_ref and player_ref.has_method("take_damage"):
		player_ref.take_damage(damage)
