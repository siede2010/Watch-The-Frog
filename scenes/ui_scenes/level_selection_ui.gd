extends Control

func _on_trigger(data) -> void:
	GameManager.load_level(data)
	pass # Replace with function body.


func _on_return_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/main.tscn"))
	pass # Replace with function body.
