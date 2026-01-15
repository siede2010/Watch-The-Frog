extends VBoxContainer

@export var destination : PackedScene
@export var levelName : String = ""
@export var index : int = 0

@onready var labelLevelName = $LevelName
@onready var buttonTexture = $TextureButton
@onready var labelTitle = $TextureButton/Title

signal setData
signal onTrigger

func _init() -> void:
	setData.connect(_setData)

func _ready():
	if not GameManager.level_list.has(index):
		GameManager.level_list.set(index,destination)
	
	GameManager.set_var("levelname-" + str(index),levelName)
	labelTitle.text = str(self.index)
	labelLevelName.text = levelName
	
	if destination == null:
		buttonTexture.disabled = true

func _setData(index, levelName, destination):
	if index:
		self.index = index
		labelTitle.text = str(self.index)
		
	if levelName:
		self.levelName = levelName
		labelLevelName.text = levelName
		GameManager.set_var("levelname-" + str(index),levelName)

	if destination:
		self.destination = destination
		



func _on_texture_button_pressed() -> void:
	GameManager.set_var("level_name",levelName)
	GameManager.set_var("level_index",index)
	onTrigger.emit(destination)
	pass # Replace with function body.
