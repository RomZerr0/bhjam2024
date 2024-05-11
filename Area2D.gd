extends Area2D
signal hit

@export var speed = 300
var target_velocity = Vector2.ZERO
var screen_size
var anim_backwards = false
var last_fired = 0
var pow = 0
var lives = 0

func start(pos):
	position = pos
	show()
	$AnimatedSprite2D.animation = "float"
	$AnimatedSprite2D.play()
	for i in range(20):
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 0)
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 1)
	$CollisionShape2D.set_deferred("disabled", false)

func die():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.stop()
	hide()
	lives = lives - 1
	if lives <= 0:
		hit.emit()
	else:
		if pow > 1:
			pow = pow / 2
		await get_tree().create_timer(3).timeout
		start(get_node("../StartPos").position) 

func _on_collision(body):
	if body.alive == false:
		if body.dmg > 0:
			die()
		else:
			pow = pow + body.pow
			body.die()
	if body.alive == true:
		body.die()
		die()
		
func fire(pow):
	var bullet_scene = load("res://player_bullet.tscn")
	var angle = PI
	var danmaku_speed = 500
	var velocity = Vector2(0, -1) * danmaku_speed
	if last_fired >= 10:
		for i in range(pow):
			var bullet = bullet_scene.instantiate()
			var offset = Vector2.ZERO
			offset.x = -(pow - 1) * 12 / 2 + i * 12
			bullet.position = global_position + (offset)
			bullet.linear_velocity = velocity
			bullet.top_level = true
			bullet.rotation = PI/2
			bullet.dmg = pow
			add_child(bullet)
		last_fired = 0

func _ready():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	screen_size = get_viewport_rect().size
	
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "left" and anim_backwards == false:
		$AnimatedSprite2D.animation = "l_loop"
		$AnimatedSprite2D.play()
	if $AnimatedSprite2D.animation == "right" and anim_backwards == false:
		$AnimatedSprite2D.animation = "r_loop"
		$AnimatedSprite2D.play()
	if $AnimatedSprite2D.animation == "right" and anim_backwards == true:
		anim_backwards = false
		$AnimatedSprite2D.animation = "float"
		$AnimatedSprite2D.play()
	if $AnimatedSprite2D.animation == "left" and anim_backwards == true:
		anim_backwards = false
		$AnimatedSprite2D.animation = "float"
		$AnimatedSprite2D.play()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity  = Vector2.ZERO
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
		if velocity.x < 0:
			if $AnimatedSprite2D.animation != "l_loop":
				$AnimatedSprite2D.animation = "left"
		if velocity.x > 0:
			if $AnimatedSprite2D.animation != "r_loop":
				$AnimatedSprite2D.animation = "right"
	else:
		if $AnimatedSprite2D.animation == "right" or $AnimatedSprite2D.animation == "r_loop":
			anim_backwards = true
			$AnimatedSprite2D.play_backwards("right")
		if $AnimatedSprite2D.animation == "left" or $AnimatedSprite2D.animation == "l_loop":
			anim_backwards = true
			$AnimatedSprite2D.play_backwards("left")

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _process(delta):
	last_fired += 1
