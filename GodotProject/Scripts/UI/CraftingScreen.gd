extends Control

func _process(delta):
	bow_buy_check()
	sword_buy_check()
	
func bow_buy_check():
	if Global.resources["Wood"] < 3:
		$Bow/BowBuy.disabled = true
	elif Global.resources["Wood"] >= 3:
		$Bow/BowBuy.disabled = false
		
func sword_buy_check():
	if Global.resources["Iron"] < 3 || Global.resources["Wood"] < 1:
		$Sword/SwordBuy.disabled = true
	elif Global.resources["Iron"] >= 3 and Global.resources["Wood"] >= 1:
		$Sword/SwordBuy.disabled = false

func _on_BowBuy_pressed():
	print("You just bought a BOW!")
	Global.resources["Wood"] -= 3

func _on_SwordBuy_pressed():
	print("You just bought a SWORD!")
	Global.resources["Iron"] -= 3
	Global.resources["Wood"] -= 1
