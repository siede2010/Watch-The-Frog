extends Node2D

@onready var buttonPlay = $ButtonPlay
@onready var buttonExit = $ButtonExit

@export var playScene : PackedScene = null

func _on_play_button_play_button_down() -> void:
	GameManager.load_level(playScene)
	
	pass # Replace with function body.


func _on_exit_button_exit_button_down() -> void:
	pass # Replace with function body.
