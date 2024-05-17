extends CanvasLayer
signal start_game
var heart_symbol = "❤️"

func _on_start_button_pressed():
	$StartButton.hide()
	$DebugFireGen/Timer.start()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
# Called when the node enters the scene tree for the first time.

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "SAMPLE TEXT"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
	
func _ready():
	$DebugFireGen/Timer.wait_time = int($DebugFireGen/LineEdit.text)
	
func _on_debug_timer_timeout():
	$DebugFireGen/Timer.wait_time = int($DebugFireGen/LineEdit.text)
	var containers = $DebugFireGen/Add.get_children()
	var params = []
	var enemy = get_tree().get_nodes_in_group("enemy")[0]
	for i in containers:
		var att = i.get_children()
		for j in att:
			params.append(j.text)
		enemy.pattern_gen(int(params[0]), params[1], params[2], int(params[3]), params[4],"default", int(params[5]), int(params[6]),Vector2.ZERO, float(params[7]), float(params[8]), int(params[9]),"rainbow",false)
		params = []
#pattern_gen(amount = 10, target = "player", type = "default", speed = 100, shape = "default", order = "default", spread = 0, scale = 2, offset = Vector2.ZERO, att_speed = 0.0, delay = 0.0, phase = 0, color = "rainbow", pregen = false, pregenerated = null):
func add():
	var y_offset = 30
	var container = HBoxContainer.new()
	if $DebugFireGen/Add.get_children() != []:
		y_offset = $DebugFireGen/Add.get_child(-1).position.y + 30
	container.position = Vector2(0,y_offset)
	var amount = LineEdit.new()
	var target = OptionButton.new()
	var type = OptionButton.new()
	var speed = LineEdit.new()
	var shape = OptionButton.new()
	var spread = LineEdit.new()
	var scl = LineEdit.new()
	var att_speed = LineEdit.new()
	var delay = LineEdit.new()
	var phase = LineEdit.new()
	amount.text = "amnt"
	speed.text = "speed"
	spread.text = "spread"
	scl.text = "scale"
	att_speed.text = "att rate"
	delay.text = "delay"
	phase.text = "phase"
	type.add_item("danmaku")
	type.add_item("danmaku_round")
	type.add_item("danmaku_crystal")
	type.add_item("danmaku_round_big")
	type.add_item("danmaku_round_small")
	type.add_item("danmaku_laser")
	target.add_item("none")
	target.add_item("self")
	target.add_item("player")
	target.add_item("center")
	target.add_item("catch")
	shape.add_item("default")
	shape.add_item("circle")
	shape.add_item("heart")
	shape.add_item("delta")
	shape.add_item("clover")
	shape.add_item("rose5")
	shape.add_item("rose7")
	shape.add_item("rose4")
	container.add_child(amount)
	container.add_child(target)
	container.add_child(type)
	container.add_child(speed)
	container.add_child(shape)
	container.add_child(spread)
	container.add_child(scl)
	container.add_child(att_speed)
	container.add_child(delay)
	container.add_child(phase)
	$DebugFireGen/Add.add_child(container)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var score = get_node("../Player").score
	if score > 0:
		$Score.text = str(score)
	else:
		$Score.text = ""
	if get_node("../Player").lives > 0:
		$Lives.text = str(heart_symbol).repeat(get_node("../Player").lives)
	else:
		$Lives.text = ""
