extends Control

func health_bar_tween(health):
	$Health/Tween.interpolate_property($Health, "value", null, health, .4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Health/Tween.start()