extends RigidBody2D
var start = Vector2.ZERO
var direction = Vector2.ZERO
var max = 780 # adjust this in distance
var dmg = 0
var pow = 0
var alive = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start = position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction
	var dist = position.distance_to(start)
	if dist > max:
		self.queue_free()
		
func die():
	self.queue_free()
