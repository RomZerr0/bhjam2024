extends RigidBody2D
var start = Vector2.ZERO
var direction = Vector2.ZERO
var max = 780 # adjust this in distance
var dmg = 1
var pow = 0
var alive = false
var delayed_linear_velocity = Vector2.ZERO
var screen_size
var delay = 0.0 #dis is movilg_delay_from_start
var timer = 0.0 #dis 4 stagger
var color = "none"
var fd = 0

func delayed_start(t = 0.0,d = 0.0):
	if t != null:
		await get_tree().create_timer(abs(t)).timeout
	show()
	if get_child(-1).name != "egg":
		fade(0.07,4)
	if d != null:
		if d <= 0:
			await get_tree().create_timer(abs(d)-abs(t)).timeout
		else:
			await get_tree().create_timer(d).timeout
	linear_velocity = delayed_linear_velocity
	#$AudioStreamPlayer.play()
	$DeathTimer.start()
	
func fade(t,d): #use msec i guess
	$FadeTimer.wait_time = t
	$FadeTimer.start()
	$FadeTimer.connect("timeout",mod_fade.bind(d))

		
func mod_fade(amount):
	amount = float(amount)
	$AnimatedSprite2D.self_modulate.a += 1/amount
	$AnimatedSprite2D.scale += Vector2(1/amount, 1/amount)
	$Sprite2D.self_modulate.a += 1/amount
	$Sprite2D.scale += Vector2(1/amount, 1/amount)
	fd += 1/amount
	if fd >= 1:
		$FadeTimer.stop()

func spawn():
	if get_child(-1).name != "egg":
		$Sprite2D.scale = Vector2(fd, fd)
		$AnimatedSprite2D.scale = Vector2(fd, fd)
		$AnimatedSprite2D.self_modulate = Color(1, 1, 1, fd)
		$Sprite2D.self_modulate = Color(1, 1, 1, fd)
	#$AudioStreamPlayer.play()
	$DeathTimer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	hide()
	$AudioStreamPlayer.stream = get_node("..").shootsnd
	if color == "none":
		$Sprite2D.material.set_shader_parameter("sin_offset", 0.0)
	if color == "red":
		$Sprite2D.material.set_shader_parameter("sin_offset", 90.0)
		$Sprite2D.material.set_shader_parameter("sin_frequency", 0.5)
	if color == "green":
		$Sprite2D.material.set_shader_parameter("sin_offset", 180.0)
	if color == "blue":
		$Sprite2D.material.set_shader_parameter("sin_offset", 270.0)
		$Sprite2D.material.set_shader_parameter("sin_frequency", 2.0)
	screen_size = get_viewport_rect().size
	start = position
	spawn()
	
func check_pos():
	if timer != 0.0:
		return
	if position.x < Vector2.ZERO.x - 50 or position.x > screen_size.x + 50 or position.y < Vector2.ZERO.y - 50 or position.y > screen_size.y + 50:
		queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	#position += direction
		
func _die():
	queue_free()

