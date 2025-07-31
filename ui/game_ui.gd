extends CanvasLayer

var score = 0

func _ready():
	# Initialize the score label
	update_score_display()
	
	# Connect to all collectibles
	for collectible in get_tree().get_nodes_in_group("collectible"):
		collectible.connect("collected", _on_collectible_collected)

func _on_collectible_collected():
	# Increase score
	score += 1
	
	# Update the score display
	update_score_display()

func update_score_display():
	# Update the score label
	$ScoreLabel.text = "Score: " + str(score)