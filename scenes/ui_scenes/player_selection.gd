extends Node2D

@onready var playerSelection = $PlayerSelect
@onready var frogSelection = $Selection
@onready var frog2ndCard = $Selection/Player_Select_Card_2

@export var nextScene : PackedScene

var confirmed = 0

func _on_btn_one_pressed() -> void:
	GameManager.set_var("player_count",1)
	nextSelection()
	pass # Replace with function body.

func nextSelection():
	playerSelection.visible = false
	frogSelection.visible = true
	frog2ndCard.visible = GameManager.get_var("player_count") == 2

func _on_btn_two_pressed() -> void:
	GameManager.set_var("player_count",2)
	nextSelection()
	
	pass # Replace with function body.


func _on_player_select_card_selection_finished() -> void:
	confirmed += 1
	if confirmed == GameManager.get_var("player_count"):
		print("Change Scene to Level")
		GameManager.load_level(nextScene)
		#get_tree().change_scene_to_packed(nextScene)
		
	pass # Replace with function body.
