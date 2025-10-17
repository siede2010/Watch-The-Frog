extends Area2D

@export var direction : int = 0
@export var points : int = 5

@onready var Sprite = $Sprite2D

func faceDirection(dir):
	if Sprite == null:
		return
	Sprite.texture.set_region(Rect2(0, (int(dir) % 4) * 18,18,18))

var prog = 0.0
func _process(delta: float) -> void:
	prog += delta
	direction += floor(prog / 1)
	prog = fmod(prog,1.0)
	faceDirection(direction)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()
	pass # Replace with function body.
