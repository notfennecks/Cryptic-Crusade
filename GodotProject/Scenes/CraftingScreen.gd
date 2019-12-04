extends Control

signal updated_player_resources(type, amount)

var total_resources = {
	"Wood" : 0,
	"Iron" : 0,
	"String": 0,
	"Stone" : 0,
	"Crystal" : 0,
	"Life Essence" : 0,
	"Mana Essence" : 0,
	"Damage Essence" : 0,
	"Bottle" : 0
	}
	
func _ready():
	connect("updated_player_resources", get_parent().get_parent().get_node("Player"), "update_player_resources")

func crafting_data(resource_name, total_amount):
	total_resources[resource_name] = total_amount
	
func _process(delta):
	bow_buy_check()
	sword_buy_check()
	
func bow_buy_check():
	if total_resources["Wood"] < 3:
		$Bow/BowBuy.disabled = true
	elif total_resources["Wood"] >= 3:
		$Bow/BowBuy.disabled = false
		
func sword_buy_check():
	if total_resources["Iron"] < 3 || total_resources["Wood"] < 1:
		$Sword/SwordBuy.disabled = true
	elif total_resources["Iron"] >= 3 and total_resources["Wood"] >= 1:
		$Sword/SwordBuy.disabled = false

func _on_BowBuy_pressed():
	total_resources["Wood"] -= 3
	emit_signal("updated_player_resources", "Wood", 3)


func _on_SwordBuy_pressed():
	total_resources["Iron"] -= 3
	emit_signal("updated_player_resources", "Iron", 3)
	total_resources["Wood"] -= 1
	emit_signal("updated_player_resources", "Wood", 1)
