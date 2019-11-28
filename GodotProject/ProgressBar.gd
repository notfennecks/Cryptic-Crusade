extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _init(current, maximum):
	max_value = maximum
	value = current

func _process(delta):
	pass

func _on_NeutralHood_experience_gained(growth_data): #func with growth data parameter
	for line in growth_data: #loop to show growth data
		var target_experience = line[0] #variable target experience
		var max_experience = line[1] #variable max experience
		max_value = max_experience #max value is the max experience
		yield(animate_value(target_experience), "completed") #stop the loop and call animate value function with target experience param
		if abs(max_value - value) < 0.01: #if the absolute value between the max value and value is under 0.01
			value = min_value #the progress bar is reset
		
func animate_value(target, tween_duration = 1.0): #function to animate the value with target and tween duration params
	$Tween.interpolate_property(self, self.value, 0, target, tween_duration, Tween.TRANS_SINE, Tween.EASE_OUT) #Tween to animate how the progress bar moves
	$Tween.start() #start the tween
	yield($Tween, "tween_completed") #stop the function obj param is the tween and signal is tween completed
