extends Node2D


func _on_tree_exited() -> void:
	GameManager.rem_spawn_point(self)
	pass # Replace with function body.


func _on_tree_entered() -> void:
	GameManager.add_spawn_point(self)
	pass # Replace with function body.
