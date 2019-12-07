extends Path2D

onready var follow = $PathFollow2D  #Onready varible for storing node path in "follow" variable.

# Called when the node enters the scene tree for the first time.
func _ready():  #Once scene is loaded run this function.
	set_process(true)  #Sets physics process to true once scene is loaded.
	
func _process(delta):   #Every frame this function is runned.
	follow.set_offset(follow.get_offset() + 350 * delta)  #This sets the follow offset value on the pre-defined path2D line every frame.
	