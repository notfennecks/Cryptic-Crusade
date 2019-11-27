extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init(current, maximum):
	max_value = maximum
	value = current
