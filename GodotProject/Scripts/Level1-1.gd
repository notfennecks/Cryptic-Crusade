extends Node2D

onready var bar = $ProgressBar
export (PackedScene) var Arrow

func _ready():
	$UI/InventoryScreen.hide()
	$UI/CraftingScreen.hide()
	
func _process(delta):
	check_ui_visibility()
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func check_ui_visibility():
	if Input.is_action_just_pressed("inventory"):
		if $UI/InventoryScreen.visible:
			$UI/InventoryScreen.hide()
		else:
			$UI/InventoryScreen.show()
	if Input.is_action_just_pressed("crafting"):
		if $UI/CraftingScreen.visible:
			$UI/CraftingScreen.hide()
		else:
			$UI/CraftingScreen.show()

func _on_Player_shoot(pos, dir):
	var a = Arrow.instance()
	a.start(pos, deg2rad(dir))
	add_child(a)
