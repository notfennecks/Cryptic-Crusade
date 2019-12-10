extends Path2D

onready var follow = $BatPathFollow
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	
func _process(delta):
	follow.set_offset(follow.get_offset() + 350 * delta)