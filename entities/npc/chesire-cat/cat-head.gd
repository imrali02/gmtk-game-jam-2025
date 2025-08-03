extends Node2D

var speed = 400
var direction = Vector2.ZERO
var bounce_count = 0
var max_bounces = 3
var damage = 15
var cat_body = null
@onready var collider = $CollisionShape2D

func _ready():
	add_to_group("rewindable")
	
	self.connect("body_entered", _on_body_entered)

func initialize(initial_direction, parent_cat):
	direction = initial_direction.normalized()
	cat_body = parent_cat

func _physics_process(delta):
	
	collider.disabled = false
	# Move the head
	position += direction * speed * delta

	# Check for wall collisions
	var level_bounds = Rect2(300, 170, 1350, 730)
	var collided = false
	
	if position.x <= 0 or position.x >= level_bounds.size.x:
		direction.x = -direction.x
		collided = true

	if position.y <= 0 or position.y >= level_bounds.size.y:
		direction.y = -direction.y
		collided = true
	
	if collided:
		bounce_count += 1
		
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
		
		if bounce_count >= max_bounces:
			return_to_cat()
			
	$Rewinder.handle_rewind()
	
func return_to_cat():
	if cat_body:
		collider.disabled = true
		var tween = create_tween()
		tween.tween_property(self, "global_position", cat_body.global_position, 0.5).set_ease(Tween.EASE_IN)
		tween.tween_callback(queue_free)

func _on_body_entered(body):
	if body.is_in_group("player") || body.is_in_group("boss"):
			body.take_damage(damage)
