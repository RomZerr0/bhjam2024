extends RigidBody2D
var hp = 10
var speed = 25
var velocity = Vector2.ZERO
var att_count = 0
var alive = true
var rng
var shootsnd

func _ready():
	shootsnd = preload("res://sfx/shoot.wav")
	rng = get_node("..").rng
	$AnimatedSprite2D.play("default")
	$Delay.start()
	
func _on_delay_expire():
	$AttackTimer.start()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
	
func die():
	alive = false
	get_node("../Player").score = get_node("../Player").score + 1000
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
	hp = hp - damage
	if hp < 1:
		die()
		
func drop_bonus():
	var bonus_scene = load("res://bonus.tscn")
	var bonus = bonus_scene.instantiate()
	bonus.pow = 1
	bonus.linear_velocity = Vector2(0, 1) * 100
	call_deferred("add_child", bonus)
		
		
func pattern_gen(amount = 10, target = "player", type = "default", speed = 100, shape = "default", order = "default", spread = 0, scale = 2, offset = Vector2.ZERO, att_speed = 0.0, delay = 0.0, phase = 0, color = "rainbow"):
	var danmaku_type
	var target_angle
	var aim: Vector2
	var spread_rad = deg_to_rad(spread)
	var angle_step_r = spread_rad / (amount - 1)
	if phase <0:
		angle_step_r = (spread_rad / (amount - 1)) * -1
	var angle_to_player
	var angle_to_player_static
	var angle_step = PI * 2 / amount
	var array = []
	var childs = []
	var dummypos = Vector2(global_position.x,global_position.y+500)

	if type == "default":
		danmaku_type = load("res://danmaku.tscn")
	if type == "round":
		danmaku_type = load("res://danmaku_round.tscn")
		
	angle_to_player_static = position.angle_to_point(aim)
	
	if target == "self":
		aim = position
	if target == "player":
		aim = get_node('../Player').position
		angle_to_player_static = position.angle_to_point(aim)
	if target == "none":
		aim = dummypos
		angle_to_player_static = position.angle_to_point(aim)
	if target == "catch":
		var predict = get_node('../Player').position + get_node('../Player').velocity.normalized()* get_node('../Player').speed *0.7
		aim = predict
		angle_to_player_static = position.angle_to_point(aim)
			
	for i in range(amount):
		var angle = angle_step * i
		var danmaku = danmaku_type.instantiate()
		angle_to_player = global_position.angle_to_point(aim)

		if shape == "default":
			danmaku.position = global_position + offset
		if shape == "circle":
			var radius = scale * 5
			var position = Vector2(cos(angle), sin(angle)) * radius
			position = position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase)) + global_position
			danmaku.position = position + offset
		if shape == "heart":
			var x = scale * (16 * pow(sin(angle), 3))
			var y = -scale * (13 * cos(angle) - 5 * cos(2 * angle) - 2 * cos(3 * angle) - cos(4 * angle))
			var position = Vector2(x, y)
			position = position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase)) + global_position
			danmaku.position = position + offset
		if shape == "delta":
			var x = scale * (2 * cos(angle) + cos(2*angle))
			var y = scale * (2 * sin(angle) - sin(2 * angle))
			var position = Vector2(x, y)
			position = position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase)) + global_position
			danmaku.position = position + offset
		if shape == "clover":
			var x = scale * (20 * (cos(angle) + cos(5*angle)/5))
			var y = scale * (20 * (sin(angle) + sin(5*angle)/5))
			var position = Vector2(x, y)
			position = position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase)) + global_position
			danmaku.position = position + offset
		if shape == "rose5":
			var x = scale * (4 * cos(angle) + cos(4 * angle))
			var y = scale * (4 * sin(angle) - sin(4 * angle))
			var position = Vector2(x, y)
			position = position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase)) + global_position
			danmaku.position = position + offset
		if shape == "rose7":
			var x = scale * (2 * cos(angle) + cos(6 * angle))
			var y = scale * (2 * sin(angle) - sin(6 * angle))
			var position = Vector2(x, y)
			position = position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase)) + global_position
			danmaku.position = position + offset
		if shape == "rose4":
			var x = scale * (2 * cos(angle) + cos(3 * angle))
			var y = scale * (2 * sin(angle) - sin(3 * angle))
			var position = Vector2(x, y)
			position = position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase)) + global_position
			danmaku.position = position + offset
			
			
		if target == "self":
			target_angle = danmaku.position.angle_to_point(aim)
			danmaku.rotation = target_angle
		if target == "player":
			target_angle = danmaku.position.angle_to_point(aim)
			var diff = target_angle - angle_to_player_static
			var a_offset = (-diff * (spread_rad * (position.distance_to(aim)/25)))
			target_angle = angle_to_player_static + a_offset
			danmaku.rotation = target_angle
		if target == "none":
			target_angle = danmaku.position.angle_to_point(aim)
			var diff = target_angle - angle_to_player_static
			var a_offset = (-diff * (spread_rad * (position.distance_to(aim)/25)))
			target_angle = angle_to_player_static + a_offset
			danmaku.rotation = target_angle
		if target == "catch":
			target_angle = danmaku.position.angle_to_point(aim)
			var diff = target_angle - angle_to_player_static
			var a_offset = (-diff * (spread_rad * (position.distance_to(aim)/25)))
			target_angle = angle_to_player_static + a_offset
			danmaku.rotation = target_angle
			
		if order == "default":
			danmaku.linear_velocity = Vector2(cos(target_angle), sin(target_angle)) * speed
		if order == "delayed":
			danmaku.linear_velocity = Vector2.ZERO
			danmaku.delayed_linear_velocity = Vector2(cos(target_angle), sin(target_angle)) * speed
		if order == "staggered":
			danmaku.linear_velocity = Vector2.ZERO
			danmaku.delayed_linear_velocity = Vector2(cos(target_angle), sin(target_angle)) * speed
			danmaku.timer = delay

		danmaku.dmg = 1
		danmaku.top_level = true
		danmaku.color = color
		array.append(danmaku)
		
	if phase <0:
		array.reverse()
	for i in array.size():
		add_child(array[i])
		childs.append(array[i])
		if att_speed != 0.0:
			await get_tree().create_timer(att_speed).timeout
		
	if order == "delayed":
		for child in childs:
			child._on_timer_timeout(delay)
		childs = []

func spawn(pos, type = "default"):
	position = pos
	show()
	$NavigationAgent2D.target_position = position
	$AnimatedSprite2D.animation = type
	alive = true
	
	if type == "default":
		hp = 5
		speed = 25
		await get_tree().create_timer(2).timeout
		start_pattern(type)
	if type == "cirno":
		hp = 500
		speed = 50
		await get_tree().create_timer(4).timeout
		start_pattern(type)

func start_pattern(type, sub = null):
	if type == "default":
		pass
		#pattern_gen(5,"player","default",150,"default","default",10,2,Vector2.ZERO, 0.1, 0.5)
			#await pattern_gen(60,"self","round",80,"heart","default",360,3,Vector2.ZERO,0.0, 1, 90)
			#await pattern_gen(5,"player","default",150,"default","default",0,1,Vector2.ZERO,0.05, 0.5, 0)
			#await pattern_gen(50,"player","round",100,"clover","default",10,1,Vector2.ZERO,0.0, 0.1, 0)
			
			

func _on_AttackTimer_expire():
	if alive:
		att_count += 1
		
		if att_count % 10 == 0:
			pattern_gen(60,"none","default",100,"circle","staggered",180,6,Vector2.ZERO,0.08, 2, 0, "red")
			pattern_gen(60,"none","default",100,"circle","staggered",180,6,Vector2.ZERO,0.08, 2, 180, "red")

		if att_count % 6 == 0:
			pattern_gen(2,"player","default",160,"circle","default",0,1,Vector2.ZERO,0, 0.2, 0)
			pattern_gen(4,"player","default",150,"circle","default",5,1,Vector2.ZERO,0, 0.2, 0)
			pattern_gen(6,"player","default",140,"circle","default",10,1,Vector2.ZERO,0, 0.2, 0)
			pattern_gen(4,"player","default",130,"circle","default",10,1,Vector2.ZERO,0, 0.2, 0)
			pattern_gen(4,"player","default",120,"circle","default",10,1,Vector2.ZERO,0, 0.2, 0)
			pattern_gen(2,"player","default",110,"circle","default",5,1,Vector2.ZERO,0, 0.2, 0)
			pattern_gen(2,"player","default",100,"circle","default",5,1,Vector2.ZERO,0, 0.2, 0)
			pattern_gen(2,"player","default",90,"circle","default",0,1,Vector2.ZERO,0, 0.2, 0)
			pattern_gen(2,"player","default",80,"circle","default",0,1,Vector2.ZERO,0, 0.2, 0)
		if att_count % 15 == 0:
			pattern_gen(60,"self","round",80,"clover","delayed",0,5,Vector2.ZERO,0.05, 1.5, 180, "blue")
			pattern_gen(60,"self","round",80,"clover","delayed",0,4,Vector2.ZERO,0.05, 1.6, 0, "blue")
			pattern_gen(60,"self","round",80,"clover","delayed",0,3,Vector2.ZERO,0.05, 1.7, -180, "blue")
			pattern_gen(60,"self","round",80,"clover","delayed",0,2,Vector2.ZERO,0.05, 1.8, -360, "blue")
		#pattern_gen(amount, aim, type, speed, shape, order, spread, scale):

		$NavigationAgent2D.target_position = Vector2(-32,-32)
		
func _process(delta):
	pass
	#var current_agent_position: Vector2 = global_position
	#var next_path_position: Vector2 = $NavigationAgent2D.get_next_path_position()
	#if next_path_position != null:
		#velocity = current_agent_position.direction_to(next_path_position) * speed
		#position += velocity * delta
