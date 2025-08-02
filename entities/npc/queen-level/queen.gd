extends CharacterBody2D

@export var player: CharacterBody2D

var SPEED = 200
var CENTER_POS = Vector2(517, 286)
var START_POS = Vector2(517, 56)

var shields_timer = 0.0
var shields_timer_max = 5.0

var rng
var randomnum

var head_scene
var sword_scene
var soldier_scene
var card_scene

var cards = []

enum {
	CENTER,
	RETURN,
	SHIELDS_FACE_DOWN,
	SHIELDS_FACE_UP,
	STAY,
}

var state = STAY

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	
	head_scene = preload("res://entities/npc/queen-level/homing_head.tscn")
	sword_scene = preload("res://entities/npc/queen-level/sword.tscn")
	soldier_scene = preload("res://entities/npc/queen-level/card_soldier.tscn")
	card_scene = preload("res://entities/npc/queen-level/card.tscn")

func _physics_process(delta):
	match state:
		CENTER:
			move(CENTER_POS, delta)
			if (self.position - CENTER_POS).length() <= 10:
				state = SHIELDS_FACE_DOWN
				self.velocity = Vector2.ZERO
				var heart_card = rng.randi() % 8
				for i in 8:
					var card = card_scene.instantiate()
					var tf = Vector2(100, 0).rotated(i * 2 * PI / 8)
					card.position += tf
					card.is_heart = (i == heart_card)
					cards.append(card)
					add_child(card)
		SHIELDS_FACE_DOWN:
			shields_timer += delta
			if shields_timer >= shields_timer_max:
				shields_timer = 0
				state = SHIELDS_FACE_UP
				for card in cards:
					card.flip()
		SHIELDS_FACE_UP:
			shields_timer += delta
			if shields_timer >= shields_timer_max:
				shields_timer = 0
				state = RETURN
				for card in cards:
					card.queue_free()
				cards.clear()
		RETURN:
			move(START_POS, delta)
			if (self.position - START_POS).length() <= 10:
				state = STAY
		STAY:
			pass

func move(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()

func launch_attack():
	var attack = rng.randi() % 4
	print(attack)
	if state == STAY:
		if attack == 0:
			# Guillotine attack
			var head = head_scene.instantiate()
			head.player = self.player
			add_child(head)
		elif attack == 1:
			# Marching cards
			var missing = rng.randi() % 4
			var direction_select = rng.randf()
			for i in 4:
				if i != missing:
					var soldier = soldier_scene.instantiate()
					if direction_select < 0.5:
						soldier.SPEED = -500
						soldier.position += Vector2(450, 50 + 100 * (i + 1))
					else:
						soldier.position += Vector2(-450, 50 + 100 * (i + 1))
					add_child(soldier)
		elif attack == 2:
			# Sword
			var sword = sword_scene.instantiate()
			add_child(sword)
		else:
			state = CENTER
