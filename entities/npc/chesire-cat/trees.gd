extends AnimatableBody2D

var damage = 15
var attack_duration = 1.5
var retract_duration = 1.0
var is_attacking = false
var original_positions = {}
var extension_distance = 150

func _ready():
	add_to_group("rewindable")
	
	# Store original positions of all trees
	var trees = get_tree().get_nodes_in_group("trees")
	for tree in trees:
		original_positions[tree.name] = tree.position
			
		# Add collision detection to each tree
		var area = Area2D.new()
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(tree.texture.get_width() * tree.scale.x, tree.texture.get_height() * tree.scale.y)
		collision.shape = shape
		area.add_child(collision)
		area.connect("body_entered", func(body): _on_body_entered(body))
		tree.add_child(area)

func attack():
	if is_attacking:
		return
		
	is_attacking = true
	
	# Extend branches
	var tween = create_tween()
	
	var trees = get_tree().get_nodes_in_group("trees")
	for tree in trees:
		var direction = Vector2.RIGHT if tree.position.x < 500 else Vector2.LEFT
		pass
		
	# Wait and then retract
	await get_tree().create_timer(attack_duration + 1.0).timeout
	retract()

func retract():
	var tween = create_tween()
	
	var trees = get_tree().get_nodes_in_group("trees")
	for tree in trees:
		pass
	
	await tween.finished
	is_attacking = false

func _on_body_entered(body):
	if body.is_in_group("player") and is_attacking:
		body.take_damage(damage)

func rewind() -> void:
	set_physics_process(false)


func resume() -> void:
	set_physics_process(true)
