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
		
func pattern_gen(amount = 10, aim = Vector2.ZERO, type = "default", speed = 100, shape = "default", order = "default", spread = 0, scale = 2):
	var danmaku_array = []
	var target_angle = PI / 2
	var danmaku_type
	if aim == Vector2.ZERO:
		aim = Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y)
	
	if type == "default":
		danmaku_type = load("res://danmaku.tscn")
	if type == "round":
		danmaku_type = load("res://danmaku_round.tscn")
		
	for i in range(amount):
		var danmaku = danmaku_type.instantiate()
		
		if shape == "default":
			danmaku.position = global_position
		if shape == "circle":
			var radius = scale * 10
			var angle_step = PI * 2 / amount
			var angle = angle_step * i
			var position = Vector2(cos(angle), sin(angle)) * radius + global_position
			danmaku.position = position
		if shape == "heart":
			var angle_to_player = global_position.angle_to_point(aim)
			var angle_step = PI * 2 / amount
			var angle = angle_step * i
			var x = scale * (16 * pow(sin(angle), 3))
			var y = -scale * (13 * cos(angle) - 5 * cos(2 * angle) - 2 * cos(3 * angle) - cos(4 * angle))
			var position = Vector2(x, y)
			position = position.rotated(angle_to_player + 3 * PI / 2) + global_position
			danmaku.position = position
	
		if aim != Vector2.ZERO:
			target_angle = danmaku.position.angle_to_point(aim)
			danmaku.rotation = target_angle
		else:
			target_angle = deg_to_rad(spread / num * i)
			danmaku.rotation = target_angle
			
		if order == "default":
			danmaku.linear_velocity = Vector2(cos(target_angle), sin(target_angle)) * speed
		if order == "delayed":
			danmaku.linear_velocity = Vector2.ZERO
			danmaku.delayed_linear_velocity = Vector2(cos(target_angle), sin(target_angle)) * speed
			
		danmaku.dmg = 1
		danmaku.top_level = true
		danmaku_array.append(danmaku)
	return(danmaku_array)

func fire_array(array, speed = 0.0, order = "normal"):
	if order == "inverted":
		array.reverse()
	for i in array:
		add_child(i)
		if speed != 0.0:
			await get_tree().create_timer(speed).timeout

func spawn(pos, type = "default", danmaku_type = "res://danmaku_round.tscn", attack_timer = 3):
	$AttackTimer.wait_time = attack_timer
	$AnimatedSprite2D.animation = type
	danmaku_scene = danmaku_type
	position = pos
	$NavigationAgent2D.target_position = position
	show()
	
func _on_AttackTimer_expire():
	if alive:
		#pattern_gen(amount, aim, type, speed, shape, order, spread, scale):
		var arrayone = pattern_gen(100,Vector2.ZERO,"round",100,"heart","default",180,4)
		#var arraytwo = pattern_gen(100,Vector2.ZERO,"default",100,"circle","default",360,1)
		fire_array(arrayone,)
		#fire_array(arraytwo,)
		$NavigationAgent2D.target_position = Vector2(-32,-32)
		
func _process(delta):
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = $NavigationAgent2D.get_next_path_position()
	if next_path_position != null:
		velocity = current_agent_position.direction_to(next_path_position) * speed
		position += velocity * delta
