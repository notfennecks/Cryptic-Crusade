extends Control

func _process(delta):
	$TabContainer/Inventory/WoodCount.text = "x " + str(Global.resources["Wood"])
	$TabContainer/Inventory/IronCount.text = "x " + str(Global.resources["Iron"])