extends CanvasLayer
var def_bg
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	#screen_size = get_viewport_rect().size
	def_bg = preload("res://bg/stolen_water_bg.png")

func bg_def():
	$background.texture = def_bg
	$background.position = screen_size/2
	$background.show()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
