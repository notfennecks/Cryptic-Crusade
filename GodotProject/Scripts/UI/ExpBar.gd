extends ProgressBar

func _ready():
	pass

func gain_experience(experience, experience_required):
	$Tween.interpolate_property(self, "value", null, experience, .4, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 0)
	$Tween.start()
	self.max_value = experience_required
	
func level_up(level):
	$Level.text = str("LVL: ", level)
