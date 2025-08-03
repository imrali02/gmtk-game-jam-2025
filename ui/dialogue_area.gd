extends Control

func _ready():
	add_to_group("ui")

func display_dialogue(message: String) -> void:
	self.visible = true
	$PanelContainer/DialogueLabel.text = message
	await get_tree().create_timer(15.0).timeout
	self.visible = false
