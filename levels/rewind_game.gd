extends Node2D

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rewind"):
		rewind()
	elif Input.is_action_just_released("rewind"):
		resume()
			
func rewind() -> void:
	$RewindablePlayer.rewind()
	
func resume() -> void:
	$RewindablePlayer.resume()
