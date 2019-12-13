extends Control

func _process(delta):
	$WoodAmount.text = "x " + str(Global.resources["Wood"])
	$IronAmount.text = "x " + str(Global.resources["Iron"])
