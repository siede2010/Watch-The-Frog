extends HBoxContainer

@export var scoreEntity : Area2D

@onready var label = $Label
@onready var texture = $TextureRect

signal update_score
signal set_color
signal set_image

var labelLength = 4
func _init():
	update_score.connect(_update_score)
	set_color.connect(_set_color)
	set_image.connect(_set_image)
	pass
	
func _ready():
	labelLength = label.text.length()
	pass
	
func _update_score(score : int):
	var t = str(score)
	while t.length() < labelLength:
		t = "0" + t
	
	label.text = t
	
func _set_color(color : Color):
	label.add_theme_color_override("font_color",color)
	var shad : ShaderMaterial =texture.material
	shad.set_shader_parameter("line_color",color)
	pass

func _set_image(newTexture : Texture):
	texture.texture = newTexture
	pass
