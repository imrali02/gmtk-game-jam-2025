extends Node2D

var speed = 300
var target = Vector2.ZERO
var direction = Vector2.ZERO
var damage = 10
var lifetime = 3.0

func _ready():
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
	
	# Create a collision shape for detecting hits
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 20
	collision.shape = shape
	area.add_child(collision)
	area.connect("body_entered", _on_body_entered)
	add_child(area)

func _physics_process(delta):
	# Move the projectile
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Deal damage to player
		if body.has_method("take_damage"):
			body.take_damage(damage)
		
		# Destroy the projectile
		queue_free()
