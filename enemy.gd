extends RigidBody2D
var hp = 10
var num = 60
var speed = 25
var danmaku_speed = 150
var velocity = Vector2.ZERO
var danmaku_scene: PackedScene
var att_count = 0
var alive = true
var rng

func _ready():
	rng = get_node("..").rng
	velocity.y = 1
	$AnimatedSprite2D.play("default")
	$Delay.start()
	
func _on_delay_expire():
	$AttackTimer.start()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
	
	
func die():
	alive = false
	if rng.randf() < 0.05:
		drop_bonus()
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 0)
	$AttackTimer.stop()
	await get_tree().create_timer(30.0).timeout
	queue_free()
	
func _on_collision(body):
	if body.dmg:
		var dmg = body.dmg
		take_damage(dmg)
		body.destroy_bullet()
	
func take_damage(damage):
	print(hp)
	hp = hp - damage
	if hp < 1:
		die()
		
func drop_bonus():
	var bonus_scene = load("res://bonus.tscn")
	var bonus = bonus_scene.instantiate()
	bonus.pow = 1
	bonus.linear_velocity = Vector2(0, 1) * 100
	call_deferred("add_child", bonus)
		
func fire(num,aim,scope,pattern = "default"):
	var playerpos = get_node("../Player").get_position()
	var spread = deg_to_rad(scope)
	var spread_step = spread / (num - 1)
	for i in range(num):
		var danmaku = danmaku_scene.instantiate()
		danmaku.position = global_position
		if aim:
			var target_angle = global_position.angle_to_point(playerpos)
			var spread_amount = spread * (i / float(num) - 0.5)
			var final_angle = target_angle + spread_amount
			var velocity = Vector2(cos(final_angle), sin(final_angle)) * danmaku_speed
			danmaku.linear_velocity = velocity
			danmaku.rotation = final_angle
		else:
			var angle = deg_to_rad(scope / num * i)
			danmaku_speed = danmaku_speed + sin(i)
			var velocity = Vector2(cos(angle), sin(angle)) * danmaku_speed
			danmaku.linear_velocity = velocity.rotated(angle)
			danmaku.rotation = angle
		danmaku.dmg = 1
		danmaku.top_level = true
		add_child(danmaku)
	
func spawn(pos, type = "default", danmaku_type = "res://danmaku_round.tscn", attack_timer = 3):
	$AttackTimer.wait_time = attack_timer
	$AnimatedSprite2D.animation = type
	danmaku_scene = danmaku_type
	position = pos
	show()
	
func _on_AttackTimer_expire():
	if alive:
		$AttackTimer.wait_time = randf_range(0,5)
		att_count = att_count + 1
		fire(120,true,15)
	
func _process(delta):
	velocity = velocity.normalized() * speed
	position += velocity * delta
