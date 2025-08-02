extends Node2D

var speed = 300
var target_position = Vector2.ZERO
var cat_body = null
var damage = 20
var bite_duration = 0.5
var is_biting = false

func _ready():
	# Add to rewindable group
	add_to_group("rewindable")
	
	# Set initial transparency
	modulate.a = 0.3
	
	# Set up collision detection
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 40
	collision.shape = shape
	area.add_child(collision)
	area.connect("body_entered", _on_body_entered)
	add_child(area)

func initialize(position_target, parent_cat):
	target_position = position_target
	cat_body = parent_cat
	
	# Start movement sequence
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 2.0)
	tween.tween_callback(appear_and_bite)

func appear_and_bite():
	# Become fully visible
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	tween.tween_callback(func(): is_biting = true)
	
	# Play bite animation
	var bite_tween = create_tween()
	bite_tween.tween_property(self, "scale", Vector2(1.3, 1.3), bite_duration/2)
	bite_tween.tween_property(self, "scale", Vector2(1.0, 1.0), bite_duration/2)
	
	# Return to cat after bite
	await get_tree().create_timer(bite_duration).timeout
	is_biting = false
	return_to_cat()

func return_to_cat():
	if cat_body:
		# Create a tween to animate the return
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		tween.parallel().tween_property(self, "global_position", cat_body.global_position, 0.5)
		tween.tween_callback(queue_free)

func _on_body_entered(body):
	if body.is_in_group("player") and is_biting:
		# Deal damage to player
		if body.has_method("take_damage"):
			body.take_damage(damage)

# Rewinder functions
func rewind() -> void:
	set_physics_process(false)


func resume() -> void:
	set_physics_process(true)
