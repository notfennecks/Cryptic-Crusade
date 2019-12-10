extends Path2D

onready var follow = $BatPathFollow

func ready():
	set_process(true)
	
func _process(delta):
	follow.set_offset(follow.get_offset() + 150 * delta)
	print(follow.get_offset())