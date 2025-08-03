extends CharacterBody2D

@export var player: CharacterBody2D

var SPEED = 500
var player_ref

var randomnum

enum {
	ROAM
}

var state = ROAM

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	
	# Find player reference
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]

func _physics_process(delta):
	match state:
		ROAM:
			move(get_circle_position(randomnum), delta)
	
	$Rewinder.handle_rewind()

func move(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()
	
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40
	 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)

func _on_timer_timeout():
	self.queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_ref.take_damage(10.0)
		$Timer.timeout.emit()
