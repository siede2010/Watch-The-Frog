extends Area2D

@export var direction : int = 0
@export var GridSpacing : int = 32
@export var moveInterval : float = 0.5

@onready var Actor = $"."
@onready var Animator = $AnimationPlayer

func _ready():
	Animator.speed_scale = 1 / moveInterval
	pass;

func _process(delta):
	Actor.position.x += sin(deg_to_rad(90*direction)) * GridSpacing * delta / moveInterval
	Actor.position.y += cos(deg_to_rad(90*direction)) * GridSpacing * delta / moveInterval
	

func _on_body_entered(body: Node2D) -> void:
	direction = (direction + 2) % 4
	Animator.speed_scale *= -1
	
	pass # Replace with function body.
