extends Area2D

@export var playerID = 1
@export var LeftInput : InputEventAction
@export var UpInput : InputEventAction
@export var RightInput : InputEventAction
@export var DownInput : InputEventAction
@export var ActionInput : InputEventAction
@export var GridSpacing : int = 32
@export var moveInterval : float = 0.5

@onready var Sprite = $Sprite2D
@onready var Animator = $AnimationPlayer
@onready var Actor = $"."

enum actions {
	Idle,
	Move_Up,
	Move_Left,
	Move_Right,
	Move_Down,
	Action
}
var currentAction = actions.Idle

func faceDirection(dir):
	if Sprite == null:
		return
	Sprite.texture.set_region(Rect2(0, (int(dir) % 4) * 32,32,32))

func _init():
	
	pass;

func _ready():
	pass;

var a = 0;
var progress = 0;
func _process(delta):
	# TEST code to see if faceRotation would act as anticipated
	
	var pDelta = clamp(delta / moveInterval,0,1-progress) # prevents weird behaviour
	if currentAction == actions.Idle:
		progress = 0
		if Animator:
			Animator.stop()
			Animator.speed_scale = 1
		if Input.is_action_pressed(LeftInput.action):
			currentAction = actions.Move_Left
			faceDirection(3)
			if Animator:
				Animator.play("jump",-1,1/moveInterval)
		elif Input.is_action_pressed(RightInput.action):
			currentAction = actions.Move_Right
			faceDirection(1)
			if Animator:
				Animator.play("jump",-1,1/moveInterval)
		elif Input.is_action_pressed(UpInput.action):
			currentAction = actions.Move_Up
			faceDirection(2)
			if Animator:
				Animator.play("jump",-1,1/moveInterval)
		elif Input.is_action_pressed(DownInput.action):
			currentAction = actions.Move_Down
			faceDirection(0)
			if Animator:
				Animator.play("jump",-1,1/moveInterval)
		
	
	if currentAction == actions.Move_Up:
		Actor.position.y -= GridSpacing * pDelta
		progress += pDelta
		if progress == 1:
			currentAction = actions.Idle
	elif currentAction == actions.Move_Down:
		Actor.position.y += GridSpacing * pDelta
		progress += pDelta
		if progress == 1:
			currentAction = actions.Idle
	elif currentAction == actions.Move_Right:
		Actor.position.x += GridSpacing * pDelta
		progress += pDelta
		if progress == 1:
			currentAction = actions.Idle
	elif currentAction == actions.Move_Left:
		Actor.position.x -= GridSpacing * pDelta
		progress += pDelta
		if progress == 1:
			currentAction = actions.Idle
	elif currentAction == actions.Action:
		pass;
	
	Actor.z_index = Actor.position.y

func defeat():
	pass;

func _on_body_entered(body: Node2D) -> void:
	# upon hitting a wall it will reverse it's action.
	# This code thinks no walls will move, will need to be changed in the future.
	if currentAction == actions.Move_Left:
		currentAction = actions.Move_Right
	elif currentAction == actions.Move_Right:
		currentAction = actions.Move_Left
	elif currentAction == actions.Move_Up:
		currentAction = actions.Move_Down
	elif currentAction == actions.Move_Down:
		currentAction = actions.Move_Up
		
	progress = 1 - progress # Inverts both the progress and speed scale.
	Animator.speed_scale *= -1
	
	pass # Replace with function body.
