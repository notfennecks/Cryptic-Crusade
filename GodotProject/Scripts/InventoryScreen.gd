extends Control

func update_resources(amount, type):
	if type == "Wood":
		$WoodAmount.text = "x " + str(amount)
	if type == "Iron":
		$IronAmount.text = "x " + str(amount)