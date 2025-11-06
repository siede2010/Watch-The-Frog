extends Area2D

@export var points : int = 5

@onready var Sprite = $Sprite2D

static var rand 

func _ready() -> void:
	if rand == null:
		rand = RandomNumberGenerator.new()
	Sprite.texture = Sprite.texture.duplicate()
	
	faceDirection(rand.randi() % 4)

func faceDirection(dir):
	if Sprite == null:
		return
	Sprite.texture.set_region(Rect2(0, (int(dir) % 4) * 18,18,18))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()
	pass # Replace with function body.
