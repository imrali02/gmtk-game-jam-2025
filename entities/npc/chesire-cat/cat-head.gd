extends Node2D

var speed = 400
var direction = Vector2.ZERO
var bounce_count = 0
var max_bounces = 3
var damage = 15
var cat_body = null

func _ready():
	add_to_group("rewindable")
	
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 30
	collision.shape = shape
	area.add_child(collision)
	area.connect("body_entered", _on_body_entered)
	add_child(area)

func initialize(initial_direction, parent_cat):
	direction = initial_direction.normalized()
	cat_body = parent_cat

func _physics_process(delta):
	# Move the head
	position += direction * speed * delta
	
	# Check for wall collisions
	var viewport_rect = get_viewport_rect().size
	var collided = false
	
	if position.x <= 0 or position.x >= viewport_rect.x:
		direction.x = -direction.x
		collided = true
		
	if position.y <= 0 or position.y >= viewport_rect.y:
		direction.y = -direction.y
		collided = true
	
	if collided:
		bounce_count += 1
		
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
		
		if bounce_count >= max_bounces:
			return_to_cat()

func return_to_cat():
	if cat_body:
		var tween = create_tween()
		tween.tween_property(self, "global_position", cat_body.global_position, 0.5).set_ease(Tween.EASE_IN)
		tween.tween_callback(queue_free)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)

func rewind() -> void:
	set_physics_process(false)


func resume() -> void:
	set_physics_process(true)
