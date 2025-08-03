extends CharacterBody2D

var player_inside = false
var dialogue = [
	"Welcome back! Did you collect any more shards from the three guardians this time? Oh, no worries! I'll be here when you get back, just like last time! Make sure to [R]ewind when your time meter reaches 100%, and give yourself [Space] with your dash! You'll get it eventually! You can give me the shard after each guardian, I'll keep them safe!",
	"Looks like you got a shard, great work! This time it only took you " + str(Global.player_deaths + 1) + " tries! The last time you were here, I think it took " + str(randi() % 1000 + 1) + " tries! And the time before that, it took " + str(randi() % 1000 + 1) + " tries, and before that it was " + str(randi() % 1000 + 1) + " tries, and then " + str(randi() % 1000 + 1) + " tries, and then before that it was ...",
	"Way to go! Just one more shard and we'll be out of here! It seems you've been here so long that writers ran out of dialogue for me to say. Wait, what are we even doing here? How did we get here? My back is killing me, the artists didn't give me a sitting sprite, I've had to stand here for eternity!",
	"You ... you got them?! YOU GOT THEM! THEY'RE ALL HERE! Please, you have to carry me out, my muscles have atrophied and I can no longer move my legs."
]

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		get_tree().call_group("ui", "display_dialogue", dialogue[Global.boss_shards])
		if Global.boss_shards >= 3:
			get_tree().paused = true
			await get_tree().create_timer(5).timeout
			get_tree().call_group("scene_changer", "fade_out_and_change_scene", Global.VICTORY_SCENE)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		$InteractLabel.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		$InteractLabel.visible = false
