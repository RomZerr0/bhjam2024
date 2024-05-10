extends RigidBody2D
var hp = 10
var num = 60
var speed = 10
var danmaku_speed = 150
var velocity = Vector2.ZERO
@export var danmaku_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.y = 1
	$AnimatedSprite2D.play("default")
	$Delay.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_delay_expire():
	$AttackTimer.start()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func spawn(pos):
	position = pos
	show()
	
func _on_AttackTimer_expire():
	for i in range(num):
		var danmaku = danmaku_scene.instantiate()
		var angle = deg_to_rad(180 / num * i)
		var velocity = Vector2(cos(angle), sin(angle)) * danmaku_speed
		danmaku.linear_velocity = velocity.rotated(angle)
		danmaku.rotation = deg_to_rad(360 / num * i)
		add_child(danmaku)
	
func _process(delta):
	velocity = velocity.normalized() * speed
	position += velocity * delta
