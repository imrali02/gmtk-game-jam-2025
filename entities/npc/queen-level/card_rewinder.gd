extends Node2D
class_name CardRewinder

var parent 

var replay_duration: float = 3.0
var rewinding: bool = false
var rewind_values = {
	"face_up": []
}

func _ready():
	parent = get_parent()
	add_to_group("rewindable")

func handle_rewind() -> void:
	if not rewinding:
		if replay_duration * Engine.physics_ticks_per_second == rewind_values["face_up"].size():
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
				
		rewind_values["face_up"].append(parent.face_up)
	else:
		compute_rewind()
		
func compute_rewind() -> void:
	rewind_values["face_up"].pop_back()
	var val = rewind_values["face_up"].pop_back()
	
	if len(rewind_values["face_up"]) <= 1:
		get_tree().call_group("rewindable", "resume")
		if val != parent.face_up:
			parent.flip()
		parent.face_up = val
		rewind_values["face_up"].clear()
		return
	
	if val != parent.face_up:
		parent.flip()
	parent.face_up = val

func rewind() -> void:
	rewinding = true
	
func resume() -> void:
	rewinding = false
