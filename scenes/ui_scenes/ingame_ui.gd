extends Control

@export var levelName : String = "My MY, NAME YOUR LEVEL MISTER!"

@onready var levelNameLabel = $LevelName/Label2
@onready var timerLabel = $Timer/Label2
@onready var scores = $Scores
@onready var remainderLabel = $Remainder/Label2


var timer = 0

signal set_score
signal update_remainder
signal update_image

func _init() -> void:
	set_score.connect(_set_score)
	update_remainder.connect(_update_remainder)
	update_image.connect(_update_image)
	GameManager.levelDataUpdate.connect(_levelDataUpdate)

func _levelDataUpdate(n,value):
	if n == "collectables":
		_update_collectables(value)

func _update_collectables(value):
	if remainderLabel:
		remainderLabel.text = "{0} Left".format([value])

func _ready() -> void:
	levelNameLabel.text = levelName
	_update_collectables(GameManager.get_var_level("collectables"))
	scores.size.y = 70 * GameManager.get_var("player_count")
	scores.find_child("P1Score").visible = GameManager.get_var("player_count") >= 2

func _process(delta: float) -> void:
	timer += delta
	
	timerLabel.text = "{0}:{1}".format([int(floor(timer/60)),str(floor(int(timer) % 60)).lpad(2,'0')])

func _update_image(player_id : int,image : Texture):
	print("UPDATEING IMAGE OR SMTH")
	scores.find_child("P{0}Score".format([player_id])).emit_signal("set_image",image)
	pass

func _set_score(player_id : int,score : int):
	scores.find_child("P{0}Score".format([player_id])).emit_signal("update_score",score)
	pass

func _update_remainder(amount : int):
	remainderLabel.text = str(amount) + " Left"
	pass
