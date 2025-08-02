extends CanvasLayer

var score = 0

func _ready():
	$RewindLabel.visible = false
	$GameOverScreen.visible = false
	
	add_to_group("rewindable")
	add_to_group("game_over")
	
	update_score_display()
	update_health_bar()

func _on_collectible_collected():
	# Increase score
	score += 1
	
	# Update the score display
	update_score_display()

func _process(delta: float) -> void:
	update_health_bar()
	
func update_health_bar() -> void:
	# May need to update with better UI
	$HealthBar.value = Global.player_health

func update_score_display():
	# Update the score label
	$ScoreLabel.text = "Score: " + str(score)
	
func rewind() -> void:
	$RewindLabel.visible = true

func resume() -> void:
	$RewindLabel.visible = false
	
func game_over() -> void:
	update_health_bar()
	$GameOverScreen.visible = true

func _on_restart_button_pressed():
	Global.restart()
