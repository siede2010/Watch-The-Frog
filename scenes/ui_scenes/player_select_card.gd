extends AspectRatioContainer

@onready var frogSprite = $Foreground/FrogFrame/Frog
@onready var frogTitle = $Foreground/Title
@onready var frogDesc = $Foreground/TextRow/TextPanel/Label
@onready var selectionBtn = $Foreground/SHBox/SelButton 
@onready var backBtn = $Foreground/FrogType/backButton
@onready var forwardBtn = $Foreground/FrogType/forwardButton
@onready var backgroundFrogImg = $Frog

@export var playerNumber = 0

signal selectionFinished

var selected = 0
var frogImages : Array[Texture2D] = []
var frogImagesBig : Array[Texture2D] = []

var frogTitles : Array[String] = [
	"Teich Frosch",
	"Regen Frosh",
	"Erd Kroete",
	"Laub Frosh"
]
var frogDescriptions : Array[String] = [
	"Leben in der naehe von Teichen. Am heufigsten verbreitet bei Zentraleuropas Feuchtgebiete.",
	"Breviceps adspersus. Stabile Population in Suedostafrika. Kommen auch in anderen farben.",
	"Weit verbreited aus der Gattund der Echten Kroeten. die haeufigste Amphibienart in Europa.",
	"Hyla arborea. Klein und Agil. Flache und Glatte haut. im Sonnenbaden Glaenzt es."
]

func _init():
	for i in 4:
		frogImages.append(load("res://assets/sprites/frogs/Frog_{0}.png".format([i])))
		frogImagesBig.append(load("res://assets/sprites/frogs/Frog_{0}_Big.png".format([i])))
func _ready():
	frogSprite.texture = frogSprite.texture.duplicate()
	backgroundFrogImg.texture = backgroundFrogImg.texture.duplicate()
	_on_selectionChanged()

func _on_selectionChanged():
	if (frogSprite):
		frogSprite.texture.atlas = frogImages[selected]
	if (backgroundFrogImg):
		backgroundFrogImg.texture.atlas = frogImagesBig[selected]
	if (frogTitle):
		frogTitle.text = frogTitles[selected]
	if (frogDesc):
		frogDesc.text = frogDescriptions[selected]
	

func _on_back_button_pressed() -> void:
	selected = (selected + 3) % 4
	_on_selectionChanged()

func _on_forward_button_pressed() -> void:
	selected = (selected + 1) % 4
	_on_selectionChanged()


func _on_button_select_pressed() -> void:
	GameManager.set_var("player_{0}_type".format([playerNumber]),selected)
	selectionBtn.disabled = true
	selectionBtn.text = "Selected"
	backBtn.disabled = true
	forwardBtn.disabled = true
	
	selectionFinished.emit()
	pass # Replace with function body.
