extends Node2D
class_name Rewinder

var parent 

var replay_duration: float = 3.0
var rewinding: bool = false
var rewind_values = {
	"position": [],
	"velocity": []
}

func _ready():
	parent = get_parent()
	add_to_group("rewindable")

func handle_rewind() -> void:
	if not rewinding:
		if replay_duration * Engine.physics_ticks_per_second == rewind_values["position"].size():
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
				
		rewind_values["position"].append(parent.global_position)
		rewind_values["velocity"].append(parent.velocity)
	else:
		compute_rewind()
		
func compute_rewind() -> void:
	rewind_values["position"].pop_back()
	var pos = rewind_values["position"].pop_back()
	
	if len(rewind_values["position"]) <= 1:
		get_tree().call_group("rewindable", "resume")
		parent.global_position = pos
		rewind_values["position"].clear()
		rewind_values["velocity"].clear()
		return
	
	parent.global_position = pos

func rewind() -> void:
	rewinding = true
	parent.get_node("CollisionShape2D").set_deferred("disabled", true)
	
func resume() -> void:
	rewinding = false
	parent.get_node("CollisionShape2D").set_deferred("disabled", false)
