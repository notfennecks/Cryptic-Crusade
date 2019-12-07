extends ProgressBar

func _ready():
	pass

func _on_Player_experience_gained(experience, experience_required):
	self.value = experience
	self.max_value = experience_required
	#$Tween.interpolate_property(self, 'value', self.min_value, experience_required, 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	#$Tween.start()
	
func _on_Player_level_up(level):
	$Level.text = str("LVL: ", level)
