extends CharacterBody2D
class_name RewindablePlayer

@export var speed = 300.0
@export var replay_duration: float = 3.0

var rewinding: bool = false
var rewind_values = {
	"position": [],
	"velocity": []
}

func _ready():
	# Called when the node enters the scene tree
	add_to_group("player")

func _on_ready():
	# Connected to the ready signal
	pass

func _process(delta: float) -> void:
	if rewinding:
		return
		
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if not rewinding:
		if replay_duration * Engine.physics_ticks_per_second == rewind_values["position"].size():
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
				
		rewind_values["position"].append(global_position)
		rewind_values["velocity"].append(velocity)
	else:
		compute_rewind(delta)
		
func compute_rewind(delta: float) -> void:
	var pos = rewind_values["position"].pop_back()
	
	if len(rewind_values["position"]) == 0:
		resume()
		global_position = pos
		return
	
	global_position = pos

func rewind() -> void:
	rewinding = true
	$CollisionShape2D.set_deferred("disabled", true)
	
func resume() -> void:
	rewinding = false
	$CollisionShape2D.set_deferred("disabled", false)
