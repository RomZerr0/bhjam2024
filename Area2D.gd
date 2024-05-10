extends Area2D
signal hit

@export var speed = 200
var target_velocity = Vector2.ZERO
var screen_size
var anim_backwards = false

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.animation = "float"
	$AnimatedSprite2D.play()

func _on_collision(body):
	$AnimatedSprite2D.stop()
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func _ready():
	hide()
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
