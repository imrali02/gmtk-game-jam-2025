extends Node2D

func _ready():
	$UI.disable_boss_ui()
	$World/Doors/QueenDoor.destination_scene = Global.QUEEN_SCENE
	$World/Doors/ChesireDoor.destination_scene = Global.CHESIRE_SCENE
	$World/Doors/CaterpillarDoor.destination_scene = Global.CATERPILLER_SCENE
	# $World/Doors/HatterDoor.destination_scene = Global.HATTER_SCENE
	
	Global.reset_values()
