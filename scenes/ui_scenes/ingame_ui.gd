extends Control

@export var levelName : String = "My MY, NAME YOUR LEVEL MISTER!"

@onready var levelNameLabel = $LevelName/Label2
@onready var timerLabel = $Timer/Label2
@onready var scores = $Scores
@onready var remainderLabel = $Remainder/Label2


var timer = 0

signal set_score
signal update_remainder

func _init() -> void:
	set_score.connect(_set_score)
	update_remainder.connect(_update_remainder)

func _ready() -> void:
	levelNameLabel.text = levelName

func _process(delta: float) -> void:
	timer += delta
	
	timerLabel.text = "{0}:{1}".format([int(floor(timer/60)),str(floor(int(timer) % 60)).lpad(2,'0')])

func _set_score(player_id : int,score : int):
	scores.find_child("P{0}Score".format([player_id])).emit_signal("update_score",score)
	pass

func _update_remainder(amount : int):
	remainderLabel.text = str(amount) + " Left"
	pass
