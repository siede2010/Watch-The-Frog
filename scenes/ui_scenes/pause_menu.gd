extends Control

signal continuePressed

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_continue_pressed() -> void:
	continuePressed.emit()

func _on_return_pressed() -> void:
	get_tree().paused = false
	GameManager.levelReturn.emit()
