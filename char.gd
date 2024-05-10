extends Area2D
signal hit

@export var speed = 200
var target_velocity = Vector2.ZERO
var screen_size 

func _on_collision(body):
	hit.emit()

func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity  = Vector2.ZERO
	if velocity  != Vector2.ZERO:
		velocity  = velocity .normalized()
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
		#$AnimatedSprite2D.play()
	else:
		pass
		#$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
