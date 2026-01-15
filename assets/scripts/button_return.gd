extends TextureButton

func _on_pressed() -> void:
	print("Pressed")
	GameManager.levelReturn.emit()
