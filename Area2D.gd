extends Area2D
signal hit

@export var speed = 300
var target_velocity = Vector2.ZERO
var screen_size
var anim_backwards = false
var last_fired = 0
var pow = 0
var lives = 0
var score = 0
var grazesnd = []
var dedsnd
var firesnd
var velocity  = Vector2.ZERO
var death_debounce_time
var kills = 0
var con = 10
var shader
var alive = true


func start(pos):
	alive = true
	position = pos
	show()
	$AnimatedSprite2D.animation = "float"
	$AnimatedSprite2D.play()
	shader.set_shader_parameter("dissolveAmount",0)

	for i in range(20):
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color(1, 1, 1, 0)
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$GPUParticles2D.set_deferred("emitting", false)
	$CollisionShape2D.set_deferred("disabled", false)
	$GrazeArea/CollisionShape2D.set_deferred("disabled", false)

func die():
	alive = false
	if Time.get_unix_time_from_system() - death_debounce_time < 1:
		return
	death_debounce_time = Time.get_unix_time_from_system() 
	$CollisionShape2D.set_deferred("disabled", true)
	$GrazeArea/CollisionShape2D.set_deferred("disabled", true)
	$AudioStreamPlayer2D.stream = dedsnd
	$AudioStreamPlayer2D.play()
	for i in range(25):
		shader.set_shader_parameter("dissolveAmount",float(i/25.00))
		await get_tree().create_timer(0.01).timeout
	$AnimatedSprite2D.stop()
	hide()
	lives = lives - 1
	
	if lives <= 0:
		score = 0
		kills = 0
		pow = 1
		hit.emit()
	else:
		if pow > 1:
			pow = pow / 2
		await get_tree().create_timer(3).timeout
		start(get_node("../StartPos").position)
		alive = true 

func _on_collision(body):
	if body.collision_layer == 1:
		if body.alive == false:
			if body.dmg > 0:
				await get_tree().create_timer(0.01).timeout
				die()
			else:
				pow = pow + body.pow
				body._die()
		if body.alive == true:
			body.die()
			await get_tree().create_timer(0.01).timeout
			die()
	if body.collision_layer == 4:
		graze()
		
func graze():
	$AudioStreamPlayer2D.stream = grazesnd[randi_range(0,len(grazesnd)-1)]
	$AudioStreamPlayer2D.play()
	$GPUParticles2D.set_deferred("emitting", true)
	score = score + 10
	
	
	
func fire(pow):
	if !alive:
		return
	var num
	var bullet_scene = load("res://player_bullet.tscn")
	var angle = PI
	var danmaku_speed = 500
	var velocity = Vector2(0, -1) * danmaku_speed
	if pow > 14:
		pow = 14
	num = int((pow / 5)) + 1
	if last_fired >= 0.1:
		for i in range(num):
			var bullet = bullet_scene.instantiate()
			var offset = Vector2.ZERO
			offset.x = -(num - 1) * 12 / 2 + i * 12
			bullet.position = global_position + (offset)
			bullet.linear_velocity = velocity
			bullet.top_level = true
			bullet.rotation = PI/2
			bullet.dmg = pow % 5 + 1
			bullet.hue = pow % 5 + 1
			add_child(bullet)
			$AudioStreamPlayer2D.stream = firesnd
			$AudioStreamPlayer2D.play(0.20)
		last_fired = 0

func _ready():
	shader = $AnimatedSprite2D.material
	hide()
	death_debounce_time = Time.get_unix_time_from_system() 
	$CollisionShape2D.set_deferred("disabled", true)
	screen_size = get_viewport_rect().size
	grazesnd = [preload("res://sfx/ice-break-14765.wav"),preload("res://sfx/ice-break-147651.wav"),preload("res://sfx/ice-break-147652.wav"),preload("res://sfx/ice-break-147653.wav"),preload("res://sfx/ice-break-147654.wav"),preload("res://sfx/ice-break-147655.wav"),preload("res://sfx/ice-break-147656.wav"),preload("res://sfx/ice-break-147657.wav")]
	dedsnd = preload("res://sfx/ded.mp3")
	firesnd = preload("res://sfx/fire.wav")
	
func egginator():
	con -= 1
	if con <= 0:
		get_node("..").egg()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity  = Vector2.ZERO
	if Input.is_action_pressed("fire"):
		fire(pow)
	if Input.is_action_pressed("concentrate"):
		$Sprite2D.show()
	else:
		$Sprite2D.hide()
	if Input.is_action_pressed("move_right"):
		velocity .x += 1
	if Input.is_action_pressed("move_left"):
		velocity .x -= 1
	if Input.is_action_pressed("move_down"):
		velocity .y += 1
	if Input.is_action_pressed("move_up"):
		velocity .y -= 1
	if velocity.length() > 0:
		if Input.is_action_pressed("concentrate"):
			velocity = velocity.normalized() * speed/2
		else:
			velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _process(delta):
	last_fired += delta 
