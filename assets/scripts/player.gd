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
var lastAction = actions.Idle

func setAction(action : actions):
	lastAction = currentAction
	currentAction = action
	
func faceDirection(dir):
	if Sprite == null:
		return
	Sprite.texture.set_region(Rect2(0, (int(dir) % 4) * 34,34,34))

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
			setAction(actions.Move_Left)
			faceDirection(3)
			if Animator:
				Animator.play("jump",-1,1/moveInterval)
		elif Input.is_action_pressed(RightInput.action):
			setAction(actions.Move_Right)
			faceDirection(1)
			if Animator:
				Animator.play("jump",-1,1/moveInterval)
		elif Input.is_action_pressed(UpInput.action):
			setAction(actions.Move_Up)
			faceDirection(2)
			if Animator:
				Animator.play("jump",-1,1/moveInterval)
		elif Input.is_action_pressed(DownInput.action):
			setAction(actions.Move_Down)
			faceDirection(0)
			if Animator:
				Animator.play("jump",-1,1/moveInterval)
		
	
	if currentAction == actions.Move_Up:
		Actor.position.y -= GridSpacing * pDelta
		progress += pDelta
		if progress == 1:
			setAction(actions.Idle)
	elif currentAction == actions.Move_Down:
		Actor.position.y += GridSpacing * pDelta
		progress += pDelta
		if progress == 1:
			setAction(actions.Idle)
	elif currentAction == actions.Move_Right:
		Actor.position.x += GridSpacing * pDelta
		progress += pDelta
		if progress == 1:
			setAction(actions.Idle)
	elif currentAction == actions.Move_Left:
		Actor.position.x -= GridSpacing * pDelta
		progress += pDelta
		if progress == 1:
			setAction(actions.Idle)
	elif currentAction == actions.Action:
		pass;
	

func defeat():
	pass;

func _on_body_entered(body: Node2D) -> void:
	# upon hitting a wall it will reverse it's action.
	# This code thinks no walls will move, will need to be changed in the future.
	print(currentAction,lastAction)
	if currentAction == actions.Move_Left:
		setAction(actions.Move_Right)
	elif currentAction == actions.Move_Right:
		setAction(actions.Move_Left)
	elif currentAction == actions.Move_Up:
		setAction(actions.Move_Down)
	elif currentAction == actions.Move_Down:
		setAction(actions.Move_Up)
	elif currentAction == actions.Idle:
		if lastAction == actions.Move_Left:
			setAction(actions.Move_Right)
		elif lastAction == actions.Move_Right:
			setAction(actions.Move_Left)
		elif lastAction == actions.Move_Up:
			setAction(actions.Move_Down)
		elif lastAction == actions.Move_Down:
			setAction(actions.Move_Up)
			
		Animator.speed_scale *= -1
		return
	
	progress = 1 - progress # Inverts both the progress and speed scale.
	Animator.speed_scale *= -1
	
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("danger"):
		queue_free()
	pass # Replace with function body.
