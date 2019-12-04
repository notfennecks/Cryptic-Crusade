extends Node2D

onready var bar = $ProgressBar
onready var character = $Player
export (PackedScene) var Arrow

func _ready():
#	bar._init(character.experience_required, character.experience_total)
	pass
	
func _on_NeutralHood_shoot(pos, dir):
	var a = Arrow.instance()
	a.start(pos, deg2rad(dir))
	add_child(a)
#<<<<<<< HEAD
#=======
	
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if $CanvasLayer/InventoryScreen.visible:
			$CanvasLayer/InventoryScreen.hide()
		else:
			$CanvasLayer/InventoryScreen.show()

	if Input.is_action_just_pressed("crafting"):
		if $CanvasLayer/CraftingScreen.visible:
			$CanvasLayer/CraftingScreen.hide()
		else:
			$CanvasLayer/CraftingScreen.show()
