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

func drop_resources(Wood, amount1, Iron, amount2, spawn_center, spawn_area):
	var rand_position = Vector2(0, 0)
	rand_position.x = (randf() * spawn_area.x) - (spawn_area.x / 2) + spawn_center.x
	rand_position.y = (randf() * spawn_area.y) - (spawn_area.y / 2) + spawn_center.y
	print(rand_position)
	for a in range(amount1):
		var w = Wood.instance()
		w.position = rand_position
		add_child(w)
		w.apply_central_impulse(Vector2(rand_range(-50, 50), -50))
	for b in range(amount2):
		var i = Iron.instance()
		i.position = rand_position
		add_child(i)
		i.apply_central_impulse(Vector2(rand_range(-50, 50), -50))
