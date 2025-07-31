extends Area2D

signal collected

func _ready():
	# Add this node to the collectible group for UI detection
	add_to_group("collectible")
	
	# Connect the body_entered signal to the _on_body_entered function
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Emit the collected signal
		emit_signal("collected")
		# Play collection animation or sound here if needed
		
		# Remove the collectible from the scene
		queue_free()