extends CanvasLayer
signal start_game
var heart_symbol = "❤️"

func _on_start_button_pressed():
	$StartButton.hide()
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
	pass
	


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
	$Playerpos.text = str(get_node("../Player").get_position())
