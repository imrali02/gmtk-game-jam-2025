extends Node2D

var speed = 300
var target = Vector2.ZERO
var direction = Vector2.ZERO
var damage = 10
var lifetime = 3.0

@export var atlas_texture: AtlasTexture
@onready var sprite = $Sprite2D

func _ready():
	# Randomize region index
	var random_column = randi() % 8
	var random_row = randi() % 5
	
	# Clone the AtlasTexture and assign a new region
	var random_texture = atlas_texture.duplicate()
	random_texture.region = Rect2(random_column * 120, random_row * 120, 120, 120)
	sprite.texture = random_texture
	
	# Set up the direction towards the target
	direction = (target - global_position).normalized()
	
	# Create a timer to destroy the projectile after lifetime
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", queue_free)
	add_child(timer)
	timer.start()
	
	# Add to rewindable group
	add_to_group("rewindable")
	
	self.connect("body_entered", _on_body_entered)

func _physics_process(delta):
	# Move the projectile
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player") || body.is_in_group("boss"):
		body.take_damage(damage)
		
		queue_free() 	# Destroy the projectile
