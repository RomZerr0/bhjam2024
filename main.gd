extends Node2D
#@export var enemy_scene: PackedScene
var rng = RandomNumberGenerator.new()
var danmaku_type: PackedScene
var screen_size 
var enemy_num
var eggs = false
var shootsnd = preload("res://sfx/shoot.wav")

func game_over():
	await get_tree().create_timer(0.2).timeout
	$HUD.show_game_over()
	$EnemyTimer.stop()
	await get_tree().create_timer(2.0).timeout
	
func spawnenemy(pos, type = "default", nav = 25):
	var enemy_scene = load("res://enemy.tscn")
	var enemy_inst = enemy_scene.instantiate()
	enemy_inst.speed = nav
	if eggs:
		enemy_inst.eggs = true
	add_child(enemy_inst)
	enemy_inst.spawn(pos, type)

func game_start():
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("bonus", "queue_free")
	enemy_num = 0
	$EnemyTimer.start()
	$Player.start($StartPos.position)
	$Player.lives = 3
	$Player.pow = 1
	
	#DEBUG ENEMY
	var enemypos = screen_size / 2
	enemypos = enemypos + Vector2(80,80)
	spawnenemy(enemypos)
	
func egg():
	eggs = true
	get_tree().call_group("enemy", "egg")
	
	
func _on_EnemyTimer_timeout():
	enemy_num += 1
	#if enemy_num < 10:
		#var enemypos = $enemypos.position
		#enemypos.x = enemypos.x + rng.randi_range(0,640)
		#spawnenemy(enemypos)
	#if enemy_num == 10:
		#var enemypos = $enemypos.position
		#enemypos.x = enemypos.x + (screen_size.x / 2)
		#spawnenemy(enemypos, "cirno")
	
func _on_Cleanup_timeout():
	get_tree().call_group("bullets", "check_pos") #фу грязища
	
func _ready():
	rng.seed = hash("rng")
	screen_size = get_viewport_rect().size
	#game_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
