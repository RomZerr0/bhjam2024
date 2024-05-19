extends Node2D
#@export var enemy_scene: PackedScene
var rng = RandomNumberGenerator.new()
var danmaku_type: PackedScene
var screen_size 
var enemy_num
var eggs = false
var enemy_scene = load("res://enemy.tscn")
var shootsnd = preload("res://sfx/shoot.wav")
var sfx_boom = preload("res://sfx/boom.wav")
var sfx_bass = preload("res://sfx/bass.wav")
var mus_game = preload("res://Hell1_awaeking.mp3")
var mus_boss = preload("res://Hell2_hellevation.mp3")

func game_over():
	await get_tree().create_timer(0.2).timeout
	$HUD.show_game_over()
	$EnemyTimer.stop()
	await get_tree().create_timer(2.0).timeout
	
func spawnenemy(pos, type = "default", nav = "out"):
	var enemy_inst = enemy_scene.instantiate()
	enemy_inst.nav = nav
	if eggs:
		enemy_inst.eggs = true
	add_child(enemy_inst)
	enemy_inst.spawn(pos, type)

func game_start():
	$Foregrond.hide()
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("bonus", "queue_free")
	enemy_num = 0
	$EnemyTimer.start()
	$Player.start($StartPos.position)
	$Player.lives = 5
	$Player.pow = 1

	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = mus_game
	$AudioStreamPlayer.play()
	
	#DEBUG ENEMY
	#var enemypos = screen_size / 2
	#enemypos = enemypos + Vector2(80,80)
	#spawnenemy(enemypos)
	
func egg():
	eggs = true
	get_tree().call_group("enemy", "egg")
	
	
func _on_EnemyTimer_timeout():
	var enemypos = $enemypos.position
	enemy_num += 1
	print(enemy_num)
	if enemy_num < 7:
		if enemy_num % 2 == 0:
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/4
			spawnenemy(enemypos, "blufluff", "swipe_right")
			enemypos.x = enemypos.x + screen_size.x/4 * 2
			spawnenemy(enemypos, "blufluff", "swipe_left")
			await get_tree().create_timer(0.6).timeout
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/4
			spawnenemy(enemypos, "blufluff", "swipe_right")
			enemypos.x = enemypos.x + screen_size.x/4 * 2
			spawnenemy(enemypos, "blufluff", "swipe_left")
			await get_tree().create_timer(0.6).timeout
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/4
			spawnenemy(enemypos, "blufluff", "swipe_right")
			enemypos.x = enemypos.x + screen_size.x/4 * 2
			spawnenemy(enemypos, "blufluff", "swipe_left")
			await get_tree().create_timer(0.6).timeout
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/4
			spawnenemy(enemypos, "blufluff", "swipe_right")
			enemypos.x = enemypos.x + screen_size.x/4 * 2
			spawnenemy(enemypos, "blufluff", "swipe_left")
	elif enemy_num < 11:
		if enemy_num % 3 == 0:
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "out")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "out")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "out")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "out")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "out")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "out")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "out")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "out")
			await get_tree().create_timer(0.6).timeout
	elif enemy_num == 12:
		enemypos = $enemypos.position
		enemypos.x = screen_size.x / 2
		spawnenemy(enemypos, "mini", "stay")
	elif enemy_num == 16:
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/4
			spawnenemy(enemypos, "mini", "stay")
			enemypos.x = enemypos.x + screen_size.x/4 * 2
			spawnenemy(enemypos, "mini", "stay")
	elif enemy_num == 23:
			enemypos = $enemypos.position
			enemypos.x = screen_size.x / 2
			spawnenemy(enemypos, "mini_2", "stay")
	elif enemy_num < 26:
		pass
	elif enemy_num < 44:
		if enemy_num % 3 == 0:
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "right")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "right")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "right")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "out")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "left")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "left")
			await get_tree().create_timer(0.6).timeout
			enemypos.x = enemypos.x + screen_size.x/10
			spawnenemy(enemypos, "blufluff", "left")
			await get_tree().create_timer(0.6).timeout
	elif enemy_num < 50:
		if enemy_num % 2 == 0:
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/4
			spawnenemy(enemypos, "blufluff", "swipe_right")
			enemypos.x = enemypos.x + screen_size.x/4 * 2
			spawnenemy(enemypos, "blufluff", "swipe_left")
			await get_tree().create_timer(0.6).timeout
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/4
			spawnenemy(enemypos, "blufluff", "swipe_right")
			enemypos.x = enemypos.x + screen_size.x/4 * 2
			spawnenemy(enemypos, "blufluff", "swipe_left")
			await get_tree().create_timer(0.6).timeout
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/4
			spawnenemy(enemypos, "blufluff", "swipe_right")
			enemypos.x = enemypos.x + screen_size.x/4 * 2
			spawnenemy(enemypos, "blufluff", "swipe_left")
			await get_tree().create_timer(0.6).timeout
			enemypos = $enemypos.position
			enemypos.x = enemypos.x + screen_size.x/4
			spawnenemy(enemypos, "blufluff", "swipe_right")
			enemypos.x = enemypos.x + screen_size.x/4 * 2
			spawnenemy(enemypos, "blufluff", "swipe_left")
	elif enemy_num == 51:
			enemypos = $enemypos.position
			enemypos.x = screen_size.x / 2
			spawnenemy(enemypos, "mini_3", "stay")
	elif enemy_num == 56:
		enemypos = $enemypos.position
		enemypos.x = enemypos.x + screen_size.x/2
		spawnenemy(enemypos, "boss", "boss")
		$AudioStreamPlayer.stream = sfx_bass
		$AudioStreamPlayer.play()
		await get_tree().create_timer(2).timeout
		$BackBufferCopy2/Boom.boom()
		$AudioStreamPlayer.stream = sfx_boom
		$AudioStreamPlayer.play()
		$Foregrond.offset.x = screen_size.x/2
		$Foregrond.offset.y = screen_size.y/2
		$Foregrond.scale = Vector2(0.01,0.01)
		$Foregrond.show()
		for i in range(50):
			$Foregrond.offset.x = int(lerp(float(screen_size.x / 2), 0.0, float(i) / 50))
			$Foregrond.offset.y = int(lerp(float(screen_size.y / 2), 0.0, float(i) / 50))
			$Foregrond.scale = Vector2(lerp(0.01, 1.0, float(i) / 50),lerp(0.01, 1.0, float(i) / 50))
			await get_tree().create_timer(0.02).timeout
		$Foregrond.offset.x = 0
		$Foregrond.offset.y = 0
		$Foregrond.scale = Vector2(1,1)
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stream = mus_boss
		$AudioStreamPlayer.play()
		
	#if enemy_num == 10:
		#var enemypos = $enemypos.position
		#enemypos.x = enemypos.x + (screen_size.x / 2)
		#spawnenemy(enemypos, "cirno")
	
func _on_Cleanup_timeout():
	get_tree().call_group("bullets", "check_pos") #фу грязища
	
func _ready():
	$Foregrond.hide()
	rng.seed = hash("rng")
	screen_size = get_viewport_rect().size
	#game_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
