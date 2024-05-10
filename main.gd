extends Node2D
#@export var enemy_scene: PackedScene
var rng = RandomNumberGenerator.new()

func game_over():
	$enemy.hide()
	get_tree().call_group("enemy", "queue_free")
	$HUD.show_game_over()
	$EnemyTimer.stop()

func game_start():
	var enemy_scene = load("res://enemy.tscn")
	var enemy_inst = enemy_scene.instantiate()
	add_child(enemy_inst)
	enemy_inst.spawn($enemypos.position)
	$Player.start($StartPos.position)
	$StartDelay.start()
	
func _on_StartDelay_timeout():
	$EnemyTimer.start()
# Called when the node enters the scene tree for the first time.
func _on_EnemyTimer_timeout():
	#var mob = enemy_scene.instantiate()
	#var mob_spawn_pos = $EnemyPath/Spawner
	#mob_spawn_pos.progress_ratio = rng.randf()
	#var direction = mob_spawn_pos.rotation + PI / 2
	#mob.position = mob_spawn_pos.position
	#var velocity = Vector2(rng.randf_range(50.0, 100.0), 0.0)
	#mob.linear_velocity = velocity.rotated(direction)
	#add_child(mob)
	pass
	#dirty hack
	#var screen_size = get_viewport_rect().size
	
	

func _ready():
	rng.seed = hash("rng")
	#game_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
