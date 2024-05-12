extends RigidBody2D
var start = Vector2.ZERO
var direction = Vector2.ZERO
var max = 780 # adjust this in distance
var dmg = 0
var pow = 0
var alive = false
var order = 0
var delayed_linear_velocity = Vector2.ZERO
var screen_size
var lifetime = 0
var timer = 0.0
var color = "none"

func _on_timer_timeout(t = timer):
	await get_tree().create_timer(t).timeout
	linear_velocity = delayed_linear_velocity
	$AudioStreamPlayer.play()
	lifetime = 0

func spawn():
	$Sprite2D.scale = Vector2(0, 0)
	$AnimatedSprite2D.scale = Vector2(0, 0)
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 0)
	$Sprite2D.self_modulate = Color(1, 1, 1, 0)
	$AudioStreamPlayer.play()
	for i in range(10):
		$AnimatedSprite2D.self_modulate.a += 0.1
		$AnimatedSprite2D.scale += Vector2(0.1, 0.1)
		$Sprite2D.self_modulate.a += 0.1
		$Sprite2D.scale += Vector2(0.1, 0.1)
		await get_tree().create_timer(0.01).timeout
	if timer != 0.0:
		await get_tree().create_timer(timer).timeout
		linear_velocity = delayed_linear_velocity
		$AudioStreamPlayer.play()
		lifetime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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
	lifetime = 0
	screen_size = get_viewport_rect().size
	start = position
	spawn()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if position.x < Vector2.ZERO.x - 30 or position.x > screen_size.x + 30 or position.y < Vector2.ZERO.y - 30 or position.y > screen_size.y + 30:
		queue_free()
	lifetime += 1
	position += direction
	if lifetime > 800:
		die()
		
func die():
	var scale = $CollisionShape2D.scale
	for i in range(10):
		$CollisionShape2D.scale = $CollisionShape2D.scale - ($CollisionShape2D.scale / 10)
		$AnimatedSprite2D.scale = $AnimatedSprite2D.scale - ($AnimatedSprite2D.scale / 10)
		$Sprite2D.scale = $Sprite2D.scale - ($Sprite2D.scale / 10)
		await get_tree().create_timer(0.5).timeout
	queue_free()
