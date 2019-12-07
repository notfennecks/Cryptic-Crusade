extends Sprite

func fade_away():
	$AnimationPlayer.play("FadeAway")
	
func clear():
	queue_free()