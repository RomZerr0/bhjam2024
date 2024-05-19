extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func fadeout():
	$BackBufferCopy.hide()
	for i in range(100):
		$BackBufferCopy2/Spell.material.set_shader_parameter("alpha",0.6-float(i)/100)
		$BackBufferCopy3/Boom.material.set_shader_parameter("alpha",1-float(i)/100)
		await get_tree().create_timer(0.1).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
