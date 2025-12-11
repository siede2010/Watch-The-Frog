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
@onready var Sprite_Defeat = $DefeatSprite
@onready var Animator = $AnimationPlayer
@onready var Actor = $"."

@export var alive = true

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
var cooldown = 0

var respawnPoint : Vector2
var respawnDuration = -1
var respawning = false
var respawnfromPoint : Vector2

signal gain_points
signal respawn
signal update_points
signal set_type
signal rep_image

var type = 0
var points = 0

func setAction(action : actions):
	lastAction = currentAction
	currentAction = action
	

func faceDirection(dir):
	if Sprite == null:
		return
	Sprite.frame_coords.y = dir % 4

func _init():
	gain_points.connect(points_add)
	respawn.connect(respawn_func)
	set_type.connect(_set_type)
	pass;
	
func _set_type(new_type : int):
	type = new_type
	if Sprite:
		Sprite.texture = load("res://assets/sprites/frogs/Frog_{0}.png".format([new_type]))
		rep_image.emit(Sprite.texture)

var animationMult = 1
func _ready():
	if get_tree().current_scene.has_signal("link_player"):
		get_tree().current_scene.emit_signal("link_player",self)
	respawnPoint = Vector2(position)
	animationMult = 1/moveInterval
	
	Sprite.texture = load("res://assets/sprites/frogs/Frog_{0}.png".format([type]))
	rep_image.emit(Sprite.texture)

var a = 0;
var progress = 0;
func _process(delta):
	cooldown -= delta
	# TEST code to see if faceRotation would act as anticipated
	if (respawning):
		respawnDuration -= delta
		if (respawnDuration < 0):
			respawning = false
			alive = true
			Sprite_Defeat.visible = false
			Sprite.visible = true
			position = respawnPoint
		else:
			if int((respawnDuration**0.5) * 20) % 2 == 0:
				position = respawnfromPoint
				Sprite_Defeat.visible = true
				Sprite.visible = false
			else:
				position = respawnPoint
				Sprite_Defeat.visible = false
				Sprite.visible = true
	
	if not alive:
		return
	
	var pDelta = clamp(delta / moveInterval,0,1-progress) # prevents weird behaviour
	if currentAction == actions.Idle:
		progress = 0
		if Animator:
			Animator.play("idle")
			Animator.speed_scale = 1
		if cooldown <= 0:
			if playerID == -1:
				if randi() % 10 == 1:
					if randi() % 4 == 1:
						setAction(actions.Move_Left)
						faceDirection(3)
						if Animator:
							Animator.play("jump",-1,animationMult)
					elif randi() % 3 == 1:
						setAction(actions.Move_Right)
						faceDirection(1)
						if Animator:
							Animator.play("jump",-1,animationMult)
					elif randi() % 2 == 1:
						setAction(actions.Move_Up)
						faceDirection(2)
						if Animator:
							Animator.play("jump",-1,animationMult)
					else:
						setAction(actions.Move_Down)
						faceDirection(0)
						if Animator:
							Animator.play("jump",-1,animationMult)
			else:
				if Input.is_action_pressed(LeftInput.action):
					setAction(actions.Move_Left)
					faceDirection(3)
					if Animator:
						Animator.play("jump",-1,animationMult)
				elif Input.is_action_pressed(RightInput.action):
					setAction(actions.Move_Right)
					faceDirection(1)
					if Animator:
						Animator.play("jump",-1,animationMult)
				elif Input.is_action_pressed(UpInput.action):
					setAction(actions.Move_Up)
					faceDirection(2)
					if Animator:
						Animator.play("jump",-1,animationMult)
				elif Input.is_action_pressed(DownInput.action):
					setAction(actions.Move_Down)
					faceDirection(0)
					if Animator:
						Animator.play("jump",-1,animationMult)
		
	
	if currentAction == actions.Move_Up:
		Actor.position.y -= GridSpacing * pDelta
		progress += pDelta
		if progress >= 1:
			setAction(actions.Idle)
	elif currentAction == actions.Move_Down:
		Actor.position.y += GridSpacing * pDelta
		progress += pDelta
		if progress >= 1:
			setAction(actions.Idle)
	elif currentAction == actions.Move_Right:
		Actor.position.x += GridSpacing * pDelta
		progress += pDelta
		if progress >= 1:
			setAction(actions.Idle)
	elif currentAction == actions.Move_Left:
		Actor.position.x -= GridSpacing * pDelta
		progress += pDelta
		if progress >= 1:
			setAction(actions.Idle)
	elif currentAction == actions.Action:
		pass;
	

func defeat():
	#if playerID == -1:
	await get_tree().create_timer(1).timeout
	respawn_func()
	pass;
	
func respawn_func():
	Animator.play("RESET")
	alive = false
	progress = 0
	currentAction = actions.Idle
	respawnfromPoint = Vector2(position)
	respawnDuration = 1;
	respawning = true
	
	print(respawnPoint,respawnfromPoint)
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
		cooldown = 0.2
		return
	
	cooldown = 0.1
	progress = 1 - progress # Inverts both the progress and speed scale.
	Animator.speed_scale *= -1
	
	pass # Replace with function body.

func points_add(p):
	points += p
	print(points)
	update_points.emit(playerID,points)
	pass

func _on_area_entered(area: Area2D) -> void:
	if not alive:
		return
	
	if area.is_in_group("danger"):
		Animator.play("Ouch")
		alive = false
		defeat()
	pass # Replace with function body.
