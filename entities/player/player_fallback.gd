extends Node2D

# This script ensures the player is visible by creating a colored shape
# if the sprite texture isn't loading properly

func _ready():
	# Check if the parent has a Sprite2D node
	var sprite = get_parent().get_node("Sprite2D")
	if sprite and not sprite.texture:
		# If sprite exists but texture is null, make the ColorRect visible
		var color_rect = get_parent().get_node("ColorRect")
		if color_rect:
			color_rect.visible = true
		else:
			# Create a ColorRect if it doesn't exist
			create_fallback_visual()

func create_fallback_visual():
	# Create a simple colored shape as fallback
	var color_rect = ColorRect.new()
	color_rect.set_name("FallbackVisual")
	color_rect.set_size(Vector2(40, 40))
	color_rect.set_position(Vector2(-20, -20))
	color_rect.color = Color(0.2, 0.6, 1.0)
	get_parent().add_child(color_rect)
	print("Created fallback visual for player")