extends CanvasLayer
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_node("..").get_viewport_rect().size
	print(screen_size)
	$BackBufferCopy/Boom.material.set_shader_parameter("size",0.0)
	 # Replace with function body.
func boom(pos = Vector2(320,384)):
	print("BOOM!")
	$BackBufferCopy/Boom.material.set_shader_parameter("size",0.0)
	$BackBufferCopy/Boom.material.set_shader_parameter("Global Position",screen_size/2)
	$BackBufferCopy/Boom.material.set_shader_parameter("Screen Size",screen_size)
	$BackBufferCopy/Boom.material.set_shader_parameter("Force",0.1)
	$BackBufferCopy/Boom.material.set_shader_parameter("Thickness",0.4)
	for i in range(100):
		$BackBufferCopy/Boom.material.set_shader_parameter("size",float(i)/100)
		await get_tree().create_timer(0.01).timeout
	$BackBufferCopy/Boom.material.set_shader_parameter("size",0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
