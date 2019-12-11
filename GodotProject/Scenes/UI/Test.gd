extends Control


func _process(delta):
	var wood = Global.resources["Wood"]
	var iron = Global.resources["Iron"]
	$TabContainer/Inventory/WoodCount.text = "x " + str(Global.resources["Wood"])
	$TabContainer/Inventory/IronCount.text = "x " + str(Global.resources["Iron"])
	if wood >= 1 and iron >= 2:
		$TabContainer/Crafting/SwordBuy.show()
	else:
		$TabContainer/Crafting/SwordBuy.hide()
		
	if wood >= 2:
		$TabContainer/Crafting/BowBuy.show()
	else:
		$TabContainer/Crafting/BowBuy.hide()

