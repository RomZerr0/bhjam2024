extends RigidBody2D
var hp = 10
var speed = 25
var velocity = Vector2.ZERO
var att_count = 0
var alive = true
var rng
var shootsnd
var next_path_position
var screen_size 
var next_target
var pregen
var eggs = false

func _ready():
	pregen = await pattern_gen(20,"self","danmaku",20,"clover","delayed",0,6,Vector2.ZERO,0.1, 4, 180, "red", true)
	screen_size = get_viewport_rect().size
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
		get_node("../Player").kills = get_node("../Player").kills + 1
		
func drop_bonus():
	var bonus_scene = load("res://bonus.tscn")
	var bonus = bonus_scene.instantiate()
	bonus.pow = 1
	bonus.linear_velocity = Vector2(0, 1) * 100
	call_deferred("add_child", bonus)
		
		
func pattern_gen(amount = 10, target = "player", type = "danmaku", speed = 100, shape = "default", order = "default", spread = 0, scale = 2, offset = Vector2.ZERO, att_speed = 0.0, delay = 0.0, phase = 0, color = "rainbow", pregen = false, pregenerated = null):
	var danmaku_type
	var target_angle
	var target_position
	var target_linear_velocity
	var aim: Vector2
	var spread_rad = deg_to_rad(spread)
	var angle_step_r
	var angle_to_player
	var angle_to_player_static
	var angle_step
	var array = []
	var childs = []
	var dummypos = Vector2(global_position.x,global_position.y+500)
	var global_position_local = global_position
	var diff
	danmaku_type = load("res://"+str(type)+".tscn")
	if eggs:
		danmaku_type = load("res://egg.tscn")
		
	if target == "self":
		aim = Vector2.ZERO
		angle_to_player_static = global_position.angle_to_point(aim)
	if target == "player":
		aim = get_node('../Player').position
		angle_to_player_static = global_position.angle_to_point(aim)
	if target == "center":
		aim = screen_size/2
		angle_to_player_static = global_position.angle_to_point(aim)
	if target == "none":
		aim = dummypos
		angle_to_player_static = global_position.angle_to_point(aim)
	if target == "catch":
		var predict = get_node('../Player').position + get_node('../Player').velocity.normalized()* get_node('../Player').speed *0.7
		aim = predict
		angle_to_player_static = position.angle_to_point(aim)	
		
	angle_step = PI * 2 / amount
	angle_step_r = spread_rad / (amount - 1)
	if phase <0:
		angle_step_r = angle_step_r * -1
	angle_to_player_static = position.angle_to_point(aim)
	
	for i in range(amount):
		var angle = angle_step * i
		angle_to_player = global_position_local.angle_to_point(aim)

		if shape == "default":
			target_position = global_position_local + offset
		if shape == "circle":
			var radius = scale * 5
			target_position = Vector2(cos(angle), sin(angle)) * radius
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase)) 
			target_position = target_position + offset
		if shape == "heart":
			var x = scale * (16 * pow(sin(angle), 3))
			var y = -scale * (13 * cos(angle) - 5 * cos(2 * angle) - 2 * cos(3 * angle) - cos(4 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position + offset
		if shape == "delta":
			var x = scale * (2 * cos(angle) + cos(2*angle))
			var y = scale * (2 * sin(angle) - sin(2 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position + offset
		if shape == "clover":
			var x = scale * (20 * (cos(angle) + cos(5*angle)/5))
			var y = scale * (20 * (sin(angle) + sin(5*angle)/5))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position + offset
		if shape == "rose5":
			var x = scale * (4 * cos(angle) + cos(4 * angle))
			var y = scale * (4 * sin(angle) - sin(4 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position + offset
		if shape == "rose7":
			var x = scale * (2 * cos(angle) + cos(6 * angle))
			var y = scale * (2 * sin(angle) - sin(6 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position + offset
		if shape == "rose4":
			var x = scale * (2 * cos(angle) + cos(3 * angle))
			var y = scale * (2 * sin(angle) - sin(3 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position + offset
			
		if target == "self":
			target_angle = (target_position+global_position).angle_to_point(global_position)
		elif target == "center":
			target_angle = (target_position+(screen_size / 2)).angle_to_point(screen_size/2)
		else:
			target_angle = (target_position+global_position_local).angle_to_point(aim)
			diff = target_angle - angle_to_player_static
			target_angle = angle_to_player_static + (-diff * (spread_rad * ((target_position+global_position_local).distance_to(aim)/25)))
		target_linear_velocity = Vector2(cos(target_angle), sin(target_angle)) * speed
			
		var danmaku = danmaku_type.instantiate()
		if target == "center":
			danmaku.position = target_position + (screen_size / 2)
		else:
			danmaku.position = target_position + global_position_local
		danmaku.delayed_linear_velocity = target_linear_velocity
		danmaku.linear_velocity = target_linear_velocity
		danmaku.rotation = target_angle
		danmaku.color = color
		
		if delay != 0 or att_speed != 0:
			danmaku.linear_velocity = Vector2.ZERO
		
		if pregen:
			array.append([target_position,target_angle,target_linear_velocity,danmaku.delayed_linear_velocity])
		else:
			array.append(danmaku)
		
	if pregen:
		return(array)
		
	if att_speed >0:
		array.reverse()
	for i in array.size():
		add_child(array[i])
		array[i].delayed_start(att_speed * i,delay)
		
func egg():
	$AnimatedSprite2D.hide()
	$egg.show()
	eggs = true
			
func fire_pregen(pregenerated, type,att_speed, delay):
	if att_speed >0:
		pregenerated.reverse()
	var array	 = []
	var danmaku_type = load("res://"+str(type)+".tscn")
	for i in pregenerated:
		var danmaku = danmaku_type.instantiate()
		danmaku.delay = delay
		danmaku.position = i[0] + global_position
		danmaku.rotation = i[1]
		danmaku.delayed_linear_velocity = i[3]
		if delay != 0 or att_speed != 0:
			danmaku.linear_velocity = Vector2.ZERO
		else:
			danmaku.linear_velocity = i[2]
		array.append(danmaku)
		
	for i in array.size():
		add_child(array[i])
		array[i].delayed_start(att_speed * i,delay)

func spawn(pos, type = "default"):
	position = pos
	#next_target = Vector2(position.x,position.y + 70)
	#next_path_position = next_target
	$AnimatedSprite2D.animation = type
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 0)
	$AnimatedSprite2D.scale = Vector2(0.0, 0.0)
	alive = true
	show()
	if eggs:
		$AnimatedSprite2D.hide()
		$egg.show()
	for i in range(10):
		$AnimatedSprite2D.self_modulate.a += 0.1
		$AnimatedSprite2D.scale += Vector2(0.1, 0.1)
		await get_tree().create_timer(0.01).timeout
	
	if type == "default":
		hp = 5
		speed = 50
		await get_tree().create_timer(2).timeout
		start_pattern(type)
	if type == "cirno":
		$AnimatedSprite2D.scale += Vector2(0.3, 0.3)
		hp = 500
		speed = 80
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
	pass
	#pregen = await pattern_gen(15,"player","default",100,"circle","default",25,6,Vector2.ZERO,0.1, 4, 180, "red", true)
	#pattern_gen(36,"center","round",80,"circle","delayed",0,70,Vector2.ZERO,0.1, 6, 180, "blue")
	#pattern_gen(36,"center","round",80,"circle","delayed",0,70,Vector2.ZERO,0.1, 6, 0, "blue")
	#if alive:
		#att_count += 1
		#pregen = await pattern_gen(15,"player","default",100,"circle","delayed",25,6,Vector2.ZERO,0.1, 4, 180, "red", true)
		#if att_count == 10:
			#pattern_gen(36,"self","default",177,"circle","default",15,2,Vector2.ZERO,0.0,0.0,0)
			#pattern_gen(36,"self","default",176,"circle","default",15,2,Vector2.ZERO,0.0,0.1,3)
			#pattern_gen(36,"self","default",175,"circle","default",15,2,Vector2.ZERO,0.0,0.2,6)
			#pattern_gen(36,"self","default",174,"circle","default",15,2,Vector2.ZERO,0.0,0.3,9)
			#pattern_gen(36,"self","default",173,"circle","default",15,2,Vector2.ZERO,0.0,0.4,12)
			#pattern_gen(36,"self","default",172,"circle","default",15,2,Vector2.ZERO,0.0,0.5,15)
			#pattern_gen(36,"self","default",171,"circle","default",15,2,Vector2.ZERO,0.0,0.6,18)
			#pattern_gen(36,"self","default",170,"circle","default",15,2,Vector2.ZERO,0.0,0.61,21)
			#pattern_gen(36,"self","default",165,"circle","default",15,2,Vector2.ZERO,0.0,0.62,24)
			#pattern_gen(36,"self","default",160,"circle","default",15,2,Vector2.ZERO,0.0,0.63,27)
			#pattern_gen(36,"self","default",155,"circle","default",15,2,Vector2.ZERO,0.0,0.64,30)
			#pattern_gen(36,"self","default",150,"circle","default",15,2,Vector2.ZERO,0.0,0.65,33)
			#pattern_gen(36,"self","default",145,"circle","default",15,2,Vector2.ZERO,0.0,0.66,36)
			
		#if att_count % 5 == 0:
			#next_path_position = position

			
			#pattern_gen(20,"player","default",100,"circle","default",0,6,Vector2.ZERO,0.05,-1)
			#pattern_gen(15,"player","default",100,"circle","default",10,6,Vector2.ZERO,0.0, 4, 180, "red", false)
			#pattern_gen("","player","round",100,"","delayed",0,"","",0.1,2,0,"red",false,pregen)
			
			#pattern_gen(60,"none","default",100,"circle","staggered",180,6,Vector2.ZERO,0.08, 2, 180, "red", false)
			#pattern_gen(0,"none","default","","","","","","",0.1,"",2,"red",false,pregen)
			#var circle_60_st_0 =  await pattern_gen(60,"none","default",100,"circle","staggered",180,6,Vector2.ZERO,0.08, 2, 0, "red", false)
			#var circle_60_st_180 = await pattern_gen(60,"none","default",100,"circle","staggered",180,6,Vector2.ZERO,0.08, 2, 180, "red", false)
			
			#place_pregen(circle_60_st_0,0.08,2)
			#place_pregen(circle_60_st_180,0.08,2)

		#if att_count % 10 == 5:
			#next_path_position = position
			
			
			#pattern_gen(60,"self","default",100,"circle","staggered",0,6,Vector2.ZERO,0.1, 2, 180, "red", false)
			#pattern_gen(60,"player","default",100,"circle","default",0,6,Vector2.ZERO,0.0, 0, 180, "red", false)
			#next_path_position = position
			#pattern_gen(2,"player","default",160,"circle","default",0,1,Vector2.ZERO,0, 0.2, 0)
			#pattern_gen(4,"player","default",150,"circle","default",5,1,Vector2.ZERO,0, 0.2, 0)
			#pattern_gen(6,"player","default",140,"circle","default",10,1,Vector2.ZERO,0, 0.2, 0)
			#pattern_gen(4,"player","default",130,"circle","default",10,1,Vector2.ZERO,0, 0.2, 0)
			#pattern_gen(4,"player","default",120,"circle","default",10,1,Vector2.ZERO,0, 0.2, 0)
			#pattern_gen(2,"player","default",110,"circle","default",5,1,Vector2.ZERO,0, 0.2, 0)
			#pattern_gen(2,"player","default",100,"circle","default",5,1,Vector2.ZERO,0, 0.2, 0)
			#pattern_gen(2,"player","default",90,"circle","default",0,1,Vector2.ZERO,0, 0.2, 0)
			#pattern_gen(2,"player","default",80,"circle","default",0,1,Vector2.ZERO,0, 0.2, 0)
		#if att_count % 15 == 0:
			#next_path_position = position
			#pattern_gen(60,"self","round",80,"clover","delayed",0,5,Vector2.ZERO,0.05, 1.5, 180, "blue")
			#pattern_gen(60,"self","round",80,"clover","delayed",0,4,Vector2.ZERO,0.05, 1.6, 0, "blue")
			#pattern_gen(60,"self","round",80,"clover","delayed",0,3,Vector2.ZERO,0.05, 1.7, -180, "blue")
			#pattern_gen(60,"self","round",80,"clover","delayed",0,2,Vector2.ZERO,0.05, 1.8, -360, "blue")
		#pattern_gen(amount, aim, type, speed, shape, order, spread, scale):
		#if att_count % 15 == 0:
			#next_target = Vector2(rng.randi_range(0,screen_size.x),rng.randi_range(0,screen_size.y))
		#if att_count % 2 == 0:
			#next_path_position = next_target
		#if att_count % 20 == 0:
			#pattern_gen(60,"self","round",80,"circle","delayed",0.15,400,Vector2.ZERO,0.1, 6, 180, "blue")
			#pattern_gen(60,"self","round",80,"circle","delayed",0.15,400,Vector2.ZERO,0.1, 6, 0, "blue")
		
		
func _process(delta):
	if eggs:
		rotation = deg_to_rad(Time.get_ticks_msec())
		print(rotation)
	if next_path_position != null:
		velocity = position.direction_to(next_path_position).normalized() * speed
		position += velocity * delta
