extends Node2D

func _ready():
	get_tree().paused = false
	
	$UI.disable_boss_ui()
	$World/Doors/QueenDoor.destination_scene = Global.QUEEN_SCENE
	$World/Doors/ChesireDoor.destination_scene = Global.CHESIRE_SCENE
	$World/Doors/CaterpillarDoor.destination_scene = Global.CATERPILLER_SCENE
	# $World/Doors/HatterDoor.destination_scene = Global.HATTER_SCENE
	
	for door in $World/Doors.get_children():
		var boss = door.name.substr(0, len(door.name) - 4).to_lower()
		if Global.defeated_bosses[boss]:
			door.visible = false
	
	Global.reset_values()
	
