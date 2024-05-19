extends CharacterBody2D

var start = Vector2.ZERO
var direction = Vector2.ZERO
var linear_velocity = Vector2.ZERO
var max = 780 # adjust this in distance
var dmg = 1
var hue = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	start = position
	#if hue == 1:
		#$AnimatedSprite2D.material.set_shader_parameter("shift_color",Color(255,255,255))
	#if hue == 2:
		#$AnimatedSprite2D.material.set_shader_parameter("shift_color",Color(223,188,255))
	#if hue == 3:
		#$AnimatedSprite2D.material.set_shader_parameter("shift_color",Color(117,144,255))
	#if hue == 4:
		#$AnimatedSprite2D.material.set_shader_parameter("shift_color",Color(41,0,121))
	#if hue == 5:
		#$AnimatedSprite2D.material.set_shader_parameter("shift_color",Color(0,0,255))
		
	if get_parent().name == "Player":
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.frame = 0 # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func destroy_bullet():
	linear_velocity = linear_velocity / 6
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play('fade')
	
func _fade():
	queue_free()

func _physics_process(delta):
	position += direction
	var dist = position.distance_to(start)
	if dist > max:
		self.queue_free()
	position += linear_velocity * delta
