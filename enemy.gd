extends RigidBody2D
var nav = "out"
var hp = 10
var speed = 25
var velocity = Vector2.ZERO
var att_count = 0
var alive = true
var mov_opp = 0
var rng
var shootsnd
var next_path_position
var screen_size 
var next_target
var pregen
var eggs = false
var last_nav = Vector2.ZERO
var tp = "blufluff"
var kills
var sfx_expl = preload("res://sfx/explosion.mp3")

func _ready():
	$Sprite2D.material = $Sprite2D.material.duplicate()
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()
	#pregen = await pattern_gen(20,"self","danmaku",20,"clover","delayed",0,6,Vector2.ZERO,0.1, 4, 180, Vector4.ZERO, true)
	screen_size = get_viewport_rect().size
	shootsnd = preload("res://sfx/shoot.wav")
	rng = get_node("..").rng
	#$AnimatedSprite2D.play("float")

	
	
func _on_delay_expire():
	$AttackTimer.start()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	die("out")
	
func die(from = "normal"):
	alive = false
	if tp == "boss":
		get_node("../Player").score = get_node("../Player").score + 100000
	else:
		if from == "normal":
			get_node("../Player").score = get_node("../Player").score + 1000
	if tp != "boss":
		if rng.randf() < 0.2:
			if from != "out":
				drop_bonus()
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$AttackTimer.stop()
	if tp == "boss":
		$AttackTimer.stop()
		$MovTimer.stop()
		speed = 100
		next_path_position = screen_size/2
		await get_tree().create_timer(0.7).timeout
		$AudioStreamPlayer.stream = shootsnd
		$AudioStreamPlayer.play()
		pattern_gen(70,"none","danmaku_feather",185,"heart","default",2800,2,Vector2.ZERO,0,0,0)
		await get_tree().create_timer(0.7).timeout
		$AudioStreamPlayer.stream = shootsnd
		$AudioStreamPlayer.play()
		pattern_gen(70,"none","danmaku_feather",185,"heart","default",2800,2,Vector2.ZERO,0,0,0)
		await get_tree().create_timer(0.7).timeout
		$AudioStreamPlayer.stream = shootsnd
		$AudioStreamPlayer.play()
		pattern_gen(70,"none","danmaku_feather",185,"heart","default",2800,2,Vector2.ZERO,0,0,0)
		await get_tree().create_timer(0.7).timeout
		$AudioStreamPlayer.stream = shootsnd
		$AudioStreamPlayer.play()
		pattern_gen(70,"none","danmaku_feather",185,"heart","default",2800,2,Vector2.ZERO,0,0,0)
		speed = 0
		var frm = $AnimatedSprite2D.frame
		$AnimatedSprite2D.play("stop")
		$AnimatedSprite2D.frame = frm
		#pattern_gen(70,"none","danmaku_feather",160,"circle","default",900,8,Vector2.ZERO,0.01,2,0)
		#pattern_gen(70,"none","danmaku_feather",172,"circle","default",900,8,Vector2.ZERO,0.01,2,0)
		pattern_gen(30,"self","danmaku_feather",185,"heart","default",999,8,Vector2.ZERO,0.01,-2,0)
		pattern_gen(30,"self","danmaku_feather",190,"heart","default",1000,8,Vector2.ZERO,-0.01,-2,120)
		pattern_gen(30,"self","danmaku_feather",200,"heart","default",1000,8,Vector2.ZERO,0,-2,240)
		pattern_gen(100,"self","danmaku",170,"delta","default",0,9,Vector2.ZERO,0.02,-3.5,0,Vector4(0.1,0,0,1))
		pattern_gen(100,"self","danmaku",120,"rose5","default",0,8,Vector2.ZERO,0.02,-3.5,0,Vector4(0,0.1,0,1))
		pattern_gen(140,"self","danmaku",185,"rose7","default",0,9,Vector2.ZERO,0.01,-3.5,0,Vector4(0,0,0.1,1))
		await get_tree().create_timer(3.5).timeout
		$AudioStreamPlayer.stream = shootsnd
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.stream = sfx_expl
		$AudioStreamPlayer.play()
		get_node("../BackBufferCopy2/Boom").boom(global_position)
		get_node("../Foregrond").fadeout()
		await get_tree().create_timer(10.5).timeout
		get_node("../HUD").game_finished()
	fade()
	
		
	await get_tree().create_timer(30.0).timeout
	queue_free()
	
func fade():
	$Sprite2D.material.set_shader_parameter("progress",0)
	$AnimatedSprite2D.material.set_shader_parameter("progress",0)
	for i in range(10):
		$Sprite2D.material.set_shader_parameter("progress",float(i)/10)
		$AnimatedSprite2D.material.set_shader_parameter("progress",float(i)/10)
		await get_tree().create_timer(0.05).timeout
	$Sprite2D.hide()
	$AnimatedSprite2D.hide
	
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
	bonus.dmg = 0
	bonus.pow = 1
	bonus.position = global_position
	bonus.linear_velocity = Vector2(0, 25)
	bonus.top_level = true
	add_child(bonus)
		
		
func pattern_gen(amount = 10, target = "player", type = "danmaku", speed = 100, shape = "default", order = "default", spread = 0, scale = 2, offset = Vector2.ZERO, att_speed = 0.0, delay = 0.0, phase = 0, color = Vector4.ZERO, pregen = false, pregenerated = null):
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
		angle_to_player_static = 0
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
		if target == "center":
			angle_to_player = 0

		if shape == "default":
			target_position = global_position_local 
		if shape == "circle":
			var radius = scale * 5
			target_position = Vector2(cos(angle), sin(angle)) * radius
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase)) 
			target_position = target_position 
		if shape == "heart":
			var x = scale * (16 * pow(sin(angle), 3))
			var y = -scale * (13 * cos(angle) - 5 * cos(2 * angle) - 2 * cos(3 * angle) - cos(4 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position
		if shape == "delta":
			var x = scale * (2 * cos(angle) + cos(2*angle))
			var y = scale * (2 * sin(angle) - sin(2 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position
		if shape == "clover":
			var x = scale * (20 * (cos(angle) + cos(5*angle)/5))
			var y = scale * (20 * (sin(angle) + sin(5*angle)/5))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position 
		if shape == "rose5":
			var x = scale * (4 * cos(angle) + cos(4 * angle))
			var y = scale * (4 * sin(angle) - sin(4 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position 
		if shape == "rose7":
			var x = scale * (2 * cos(angle) + cos(6 * angle))
			var y = scale * (2 * sin(angle) - sin(6 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position
		if shape == "rose4":
			var x = scale * (2 * cos(angle) + cos(3 * angle))
			var y = scale * (2 * sin(angle) - sin(3 * angle))
			target_position = Vector2(x, y)
			target_position = target_position.rotated(angle_to_player + 3 * PI / 2 + deg_to_rad(phase))
			target_position = target_position 
			
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
			danmaku.position = target_position + (screen_size / 2) + offset
		else:
			danmaku.position = target_position + global_position_local + offset
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
	$Sprite2D.hide()
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

func spawn(pos, type = "blufluff"):
	tp = type
	position = pos
	kills = get_node("../Player").kills
	$MovTimer.start()
	#next_target = Vector2(position.x,position.y + 70)
	#next_path_position = next_target
	$Sprite2D.self_modulate = Color(1, 1, 1, 0)
	$Sprite2D.scale = Vector2(0.0, 0.0)
	alive = true
	show()
	if tp == "boss":
		$Delay.wait_time = 6.0
	$Delay.start()
	if eggs:
		$Sprite2D.hide()
		$AnimatedSprite2D.hide()
		$egg.show()
	for i in range(3):
		$Sprite2D.self_modulate.a += 0.3
		if pos.x < screen_size.x / 2:
			$Sprite2D.scale.y += 0.1
			$Sprite2D.scale.x -= 0.1
		else:
			$Sprite2D.scale += Vector2(0.1, 0.1)
		await get_tree().create_timer(0.01).timeout
	
	if type == "blufluff":
		hp = 10
		speed = 75
		await get_tree().create_timer(2).timeout
	if type == "boss":
		$Sprite2D.hide()
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.play("default")
		$CollisionShape2D.scale += Vector2(0.3, 0.3)
		$Area2D/CollisionShape2D.scale += Vector2(0.3, 0.3)
		hp = 85 * kills
		await get_tree().create_timer(8).timeout
		
	if type == "mini":
		hp = 150
		speed = 65
		await get_tree().create_timer(2).timeout
		
	if type == "mini_2":
		hp = 500
		speed = 65
		await get_tree().create_timer(2).timeout
		
	if type == "mini_3":
		$CollisionShape2D.scale += Vector2(0.3, 0.3)
		$Sprite2D.scale += Vector2(0.3, 0.3)
		hp = 1000
		speed = 65
		await get_tree().create_timer(2).timeout


func move():
	mov_opp += 1
	if nav == "swipe_right":
		if mov_opp < 40:
			next_path_position = position + Vector2(0,25)
		elif mov_opp < 80:
			next_path_position = position + Vector2(15,15)
		elif mov_opp < 100:
			next_path_position = position + Vector2(25,0)
		elif mov_opp < 120:
			next_path_position = position + Vector2(15,-15)
		else:
			next_path_position = position + Vector2(0,-15)
	if nav == "swipe_left":
		if mov_opp < 40:
			next_path_position = position + Vector2(0,25)
		elif mov_opp < 80:
			next_path_position = position + Vector2(-15,15)
		elif mov_opp < 100:
			next_path_position = position + Vector2(-25,0)
		elif mov_opp < 120:
			next_path_position = position + Vector2(-15,-15)
		else:
			next_path_position = position + Vector2(0,-15)
	if nav == "out":
		if mov_opp < 100:
			next_path_position = position + Vector2(0,25)
		elif mov_opp < 200:
			next_path_position = position
		else:
			next_path_position = position + Vector2(0,-15)
	if nav == "right":
		if mov_opp < 100:
			next_path_position = position + Vector2(5,15)
		elif mov_opp < 300:
			next_path_position = position + Vector2(70, 15) 
	if nav == "left":
		if mov_opp < 100:
			next_path_position = position + Vector2(-5,15)
		elif mov_opp < 300:
			next_path_position = position + Vector2(-70, 15)
	if nav == "stay":
		if mov_opp < 50:
			next_path_position = position + Vector2(0,25)
		elif mov_opp < 400:
			next_path_position = position
		elif mov_opp < 1500:
			next_path_position = position + Vector2(0,-25)
	if nav == "boss":
		print(mov_opp)
		var offset = Vector2(0,10)
		if mov_opp < 100:
			next_path_position = position + Vector2(0,10)
		elif mov_opp < 400:
			next_path_position = position
		elif int(mov_opp / 200) % 2 == 0:
			$AnimatedSprite2D.flip_h = false
			next_path_position = Vector2(128,128)
		else:
			$AnimatedSprite2D.flip_h = true
			next_path_position = Vector2(512,128)

func _on_AttackTimer_expire():
	$AudioStreamPlayer.stream = shootsnd
	print(str(kills)+"kills")
	if !alive:
		return
	att_count += 1
	if tp == "blufluff":
		if nav == "swipe_right" or nav == "swipe_left":
			pattern_gen(1,"player","danmaku_round",280,"circle","default",7,1,Vector2.ZERO,0,0,0,Vector4(1,1,1,1))
			$AudioStreamPlayer.play()
		if nav == "out":
			if att_count % 3 == 0:
				pattern_gen(18,"self","danmaku_round",280,"circle","default",0,1,Vector2(0,-5),0,1,0,Vector4(1,0,0,1))
				pattern_gen(18,"self","danmaku_round",250,"circle","default",0,1,Vector2(0,-5),0,1,0,Vector4(1,0,0,1))
				pattern_gen(18,"self","danmaku_round",230,"circle","default",0,1,Vector2(0,-5),0,1,0,Vector4(1,0,0,1))
				await get_tree().create_timer(1).timeout
				$AudioStreamPlayer.play()
		if nav == "left" or nav == "right":
			if att_count % 2 == 0:
				pattern_gen(10,"player","danmaku",230,"circle","default",0,4,Vector2(0,0),0,0.1,0,Vector4(1,1,1,1))
				pattern_gen(10,"player","danmaku",220,"circle","default",2,4,Vector2(0,0),0,0.15,0,Vector4(1,1,1,1))
				pattern_gen(10,"player","danmaku",210,"circle","default",4,4,Vector2(0,0),0,0.20,0,Vector4(1,1,1,1))
				pattern_gen(10,"player","danmaku",200,"circle","default",8,4,Vector2(0,0),0,0.25,0,Vector4(1,1,1,1))
				$AudioStreamPlayer.play()
	if tp == "mini":
		if att_count % 3 == 0:
			pattern_gen(36,"self","danmaku_round",300,"rose5","default",0,14,Vector2(0,0),0.01,-0.5,0,Vector4(0,1,0,1))
			pattern_gen(36,"self","danmaku_round",290,"rose5","default",0,13,Vector2(0,0),0.01,-0.55,5,Vector4(0,1,0,1))
			pattern_gen(36,"self","danmaku_round",280,"rose5","default",0,12,Vector2(0,0),0.01,-0.6,10,Vector4(0,1,0,1))
			pattern_gen(36,"self","danmaku_round",270,"rose5","default",0,11,Vector2(0,0),0.01,-0.65,15,Vector4(0,1,0,1))
			pattern_gen(36,"self","danmaku_round",260,"rose5","default",0,10,Vector2(0,0),0.01,-0.7,20,Vector4(0,1,0,1))
			pattern_gen(36,"self","danmaku_round",250,"rose5","default",0,9,Vector2(0,0),0.01,-0.75,25,Vector4(0,1,0,1))
			pattern_gen(36,"self","danmaku_round",240,"rose5","default",0,8,Vector2(0,0),0.01,-0.8,30,Vector4(0,1,0,1))
			pattern_gen(36,"self","danmaku_round",230,"rose5","default",0,7,Vector2(0,0),0.01,-0.85,35,Vector4(0,1,0,1))
			await get_tree().create_timer(0.5).timeout
			$AudioStreamPlayer.play()
			await get_tree().create_timer(0.1).timeout
			$AudioStreamPlayer.play()
			await get_tree().create_timer(0.1).timeout
			$AudioStreamPlayer.play()
			await get_tree().create_timer(0.1).timeout
			$AudioStreamPlayer.play()
	if tp == "mini_2":
		if att_count % 2 == 0:
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			pattern_gen(36,"self","danmaku_round",270,"circle","default",0,1,Vector2(0,0),0.02,0,0,Vector4(1,0,0,1))
			pattern_gen(36,"self","danmaku_round",270,"circle","default",0,1,Vector2(0,0),0.02,0,120,Vector4(1,0,0,1))
			pattern_gen(36,"self","danmaku_round",270,"circle","default",0,1,Vector2(0,0),0.02,0,240,Vector4(1,0,0,1))
			pattern_gen(36,"self","danmaku_round",280,"circle","default",0,1,Vector2(0,0),-0.02,1,0,Vector4(1,0,0,1))
			pattern_gen(36,"self","danmaku_round",280,"circle","default",0,1,Vector2(0,0),-0.02,1,120,Vector4(1,0,0,1))
			pattern_gen(36,"self","danmaku_round",280,"circle","default",0,1,Vector2(0,0),-0.02,1,240,Vector4(1,0,0,1))
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			$AudioStreamPlayer.play
			await get_tree().create_timer(0.01).timeout
			await get_tree().create_timer(1).timeout
			$AudioStreamPlayer.play()
		if att_count % 5 == 0:
			pattern_gen(60,"self","danmaku_round_small",270,"clover","default",0,4,Vector2(0,0),0.01,-1,0,Vector4(0,1,0,1))
			pattern_gen(60,"self","danmaku_round_small",260,"clover","default",0,5,Vector2(0,0),0.01,-1.1,45,Vector4(0,1,0,1))
			pattern_gen(60,"self","danmaku_round_small",250,"clover","default",0,6,Vector2(0,0),0.01,-1.2,0,Vector4(0,1,0,1))
			await get_tree().create_timer(0.1).timeout
			$AudioStreamPlayer.play()
	if tp == "mini_3":
		if att_count % 3 == 0:
			pattern_gen(50,"player","danmaku",200,"heart","default",2,4,Vector2(0,0),0.02,-1,0,Vector4(1,0,0,1))
			await get_tree().create_timer(1).timeout
			$AudioStreamPlayer.play()
		if att_count % 15 == 0:
			pattern_gen(50,"center","danmaku_round_big",150,"circle","default",0,50,Vector2(-50,-50),0.2,2,0,Vector4(1,0,0,1))
			pattern_gen(50,"center","danmaku_round_big",150,"circle","default",0,50,Vector2(-50,50),0.2,2,180,Vector4(1,0,0,1))
			pattern_gen(50,"center","danmaku_round_big",150,"circle","default",0,50,Vector2(50,-50),-0.2,2,0,Vector4(1,0,0,1))
			pattern_gen(50,"center","danmaku_round_big",150,"circle","default",0,50,Vector2(50,50),-0.2,2,180,Vector4(1,0,0,1))
			await get_tree().create_timer(2).timeout
			$AudioStreamPlayer.play()
	if tp == "boss":
		#wings
		pattern_gen(25,"none","danmaku_feather",175,"circle","default",400,2,Vector2.ZERO,0.05,0.52,90)
		pattern_gen(25,"none","danmaku_feather",175,"circle","default",400,2,Vector2.ZERO,-0.05,0.52,90)
		if att_count % 2 == 0:
			if kills > 24:
				pattern_gen(6,"player","danmaku",120,"circle","default",7,1,Vector2.ZERO,0.33,0,0,Vector4(0.2,0,0,1))
				$AudioStreamPlayer.play()
		if att_count % 4 == 0:
			if kills > 31:
				pattern_gen(9,"player","danmaku_feather",155,"circle","default",4,2,Vector2.ZERO,-0.05,0.52,90,Vector4(0.7,0,0,1))
				await get_tree().create_timer(0.52).timeout
				$AudioStreamPlayer.play()
		if att_count % 5 ==0:
			if kills > 56:
			#center
				pattern_gen(16,"center","danmaku_round",140,"circle","default",0,2,Vector2.ZERO,0.33,0,90,Vector4(0,0,0,1))
				pattern_gen(16,"center","danmaku_round",140,"circle","default",0,2,Vector2.ZERO,-0.33,0,270,Vector4(0,0,0,1))
				await get_tree().create_timer(0.33).timeout
				$AudioStreamPlayer.play()
		if att_count > 25:
			if kills > 70:
				if att_count %2 == 0:
					pattern_gen(36,"self","danmaku_round",270,"circle","default",0,1,Vector2(0,0),0.02,0,0,Vector4(1,0,0,1))
					pattern_gen(36,"self","danmaku_round",270,"circle","default",0,1,Vector2(0,0),0.02,0,120,Vector4(1,0,0,1))
					pattern_gen(36,"self","danmaku_round",270,"circle","default",0,1,Vector2(0,0),0.02,0,240,Vector4(1,0,0,1))
					pattern_gen(36,"self","danmaku_round",280,"circle","default",0,1,Vector2(0,0),-0.02,1,0,Vector4(1,0,0,1))
					pattern_gen(36,"self","danmaku_round",280,"circle","default",0,1,Vector2(0,0),-0.02,1,120,Vector4(1,0,0,1))
					pattern_gen(36,"self","danmaku_round",280,"circle","default",0,1,Vector2(0,0),-0.02,1,240,Vector4(1,0,0,1))
					await get_tree().create_timer(1).timeout
					$AudioStreamPlayer.play()
		
		
func _process(delta):
	if eggs:
		rotation = deg_to_rad(Time.get_ticks_msec())
	if next_path_position != null:
		velocity = position.direction_to(next_path_position).normalized() * speed
		position += velocity * delta
