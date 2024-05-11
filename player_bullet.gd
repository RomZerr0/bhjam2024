extends CharacterBody2D

var start = Vector2.ZERO
var direction = Vector2.ZERO
var linear_velocity = Vector2.ZERO
var max = 780 # adjust this in distance
var dmg = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	start = position
	if get_parent().name == "Player":
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.frame = 0 # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func destroy_bullet():
	linear_velocity = linear_velocity / 6
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play('fade')
	
func _fade():
	queue_free()

func _physics_process(delta):
	position += direction
	var dist = position.distance_to(start)
	if dist > max:
		self.queue_free()
	position += linear_velocity * delta
