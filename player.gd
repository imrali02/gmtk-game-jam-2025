extends CharacterBody2D

@export var speed = 300.0

func _ready():
	# Called when the node enters the scene tree
	# Add this node to the player group for collectible detection
	add_to_group("player")

func _on_ready():
	# Connected to the ready signal
	pass

func _physics_process(delta):
	# Get input direction
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Set velocity based on direction and speed
	velocity = direction * speed
	
	# Move the character
	move_and_slide()