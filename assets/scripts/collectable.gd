extends Area2D

@export var points : int = 5

@onready var Sprite = $Sprite2D
@onready var AnimPlayer = $AnimationPlayer

static var rand 
var collected = false

func _ready() -> void:
	GameManager.add_var_level("collectables",1)
	if rand == null:
		rand = RandomNumberGenerator.new()
	Sprite.texture = Sprite.texture.duplicate()
	
	faceDirection(rand.randi() % 4)

func faceDirection(dir):
	if Sprite == null:
		return
	Sprite.frame = dir



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and not collected:
		collected = true
		if area.has_signal("gain_points"):
			area.emit_signal("gain_points",points)
		AnimPlayer.play("collect")
		GameManager.add_var_level("collectables",-1)
		await AnimPlayer.animation_finished
		queue_free()
	pass # Replace with function body.
