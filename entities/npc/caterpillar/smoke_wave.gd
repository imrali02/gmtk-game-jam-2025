extends Node2D

var lifetime = 3.0
var damage = 5
var damage_interval = 0.5
var expanding = false
var max_radius = 150
var expansion_speed = 100
var current_radius = 50

var damage_timer = null
var player_in_cloud = false
var boss_in_cloud = false
var player = null
var boss = null

func _ready():
	# Create a timer to destroy the cloud after lifetime
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", queue_free)
	add_child(timer)
	timer.start()

	add_to_group("rewindable")
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		
	var bosses = get_tree().get_nodes_in_group("caterpillar")
	if bosses.size() > 0:
		boss = bosses[0]
	
	damage_timer = Timer.new()
	damage_timer.wait_time = damage_interval
	damage_timer.connect("timeout", _on_damage_timer_timeout)
	add_child(damage_timer)

func _physics_process(delta):
	if expanding:
		current_radius += expansion_speed * delta
		
	var collision = $CollisionShape2D
	if collision.shape is CircleShape2D:
		collision.shape.radius = current_radius

	var sprite = $Sprite2D
	var scale_factor = current_radius / 30.0
	sprite.scale = Vector2(scale_factor, scale_factor)
	
	if current_radius >= max_radius:
		expanding = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_cloud = true
		damage_timer.start()
	if body.is_in_group("caterpillar"):
		boss_in_cloud = true
		damage_timer.start()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_cloud = false
		damage_timer.stop()
	if body.is_in_group("caterpillar"):
		boss_in_cloud = false
		damage_timer.stop()

func _on_damage_timer_timeout():
	if player_in_cloud and player.has_method("take_damage"):
		player.take_damage(damage)
	if boss_in_cloud and boss.has_method("take_damage") and $Rewinder.rewinding:
		print("smoke hitting boss")
		boss.take_damage(damage)
