extends Area2D

@export var GridSpacing : int = 32
@export var moveInterval : float = 0.5
@export var chaseMult : float = 1.5

@onready var Actor = $"."
@onready var Sprite = $Sprite
# @onready var Animator = $AnimationPlayer
@onready var Rays : Array[RayCast2D] = [
	$RayDown,
	$RayRight,
	$RayUp,
	$RayLeft
]

var direction : int = 0
var nextDirection : int = 0
var chasing : bool = false

func faceDirection(dir):
	if Sprite == null:
		return
	Sprite.frame_coords.y = dir % 4

func _ready():
	pass;

var progress : float = 0
func _process(delta):
	var pDelta = delta / moveInterval
	if chasing:
		pDelta *= chaseMult
	pDelta = min(1-progress,pDelta)
	progress += pDelta
	Actor.position.x += sin(deg_to_rad(90*direction)) * GridSpacing * pDelta
	Actor.position.y += cos(deg_to_rad(90*direction)) * GridSpacing * pDelta
	
	var i = 0
	for ray in Rays:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if not collider.is_class("TileMapLayer") and collider.is_in_group("player") and collider.alive:
				nextDirection = i 
				chasing = true
				break
		i+=1 
	
	if progress >= 1:
		progress = 0
		if direction == nextDirection and randi() % 10 == 0:
			nextDirection = randi() % 4
		direction = nextDirection
		faceDirection(direction)
		
	Sprite.frame_coords.x = floor(progress * 4)

func _on_body_entered(body: Node2D) -> void:
	nextDirection = direction + (randi() % 3) + 1 % 4
	direction = (direction + 2) % 4
	faceDirection(direction)
	progress = 1 - progress
	chasing = false
