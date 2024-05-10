extends RigidBody2D
var start = Vector2.ZERO
var direction = Vector2.ZERO
var max = 780 # adjust this in distance

# Called when the node enters the scene tree for the first time.
func _ready():
	start = position # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction
	var dist = position.distance_to(start)
	if dist > max:
		self.queue_free()
