extends Node2D

@onready var ui = $UI

signal link_player

func _init() -> void:
	link_player.connect(_link_player)
	pass
	
func _link_player(gameObject : Node):
	print("Linking player ",gameObject.playerID)
	var link_update_points = func(num : int,score : int):
		ui.emit_signal("set_score",num,score)
	gameObject.connect("update_points",link_update_points)
	gameObject.connect("rep_image",func(image : Texture): ui.emit_signal("update_image",gameObject.playerID,image))
