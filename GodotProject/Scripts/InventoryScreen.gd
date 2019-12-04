extends Control

signal crafting_data_updated(resource_name, total_amount)

func update_resources(amount, type):
	connect("crafting_data_updated", get_parent().get_child(1), "crafting_data")
	emit_signal("crafting_data_updated", type, amount)
	if type == "Wood":
		$WoodAmount.text = "x " + str(amount)
	if type == "Iron":
		$IronAmount.text = "x " + str(amount)
		
