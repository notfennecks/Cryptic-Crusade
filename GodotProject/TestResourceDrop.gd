extends Node2D

signal resource_dropped(amount1, amount2)

export (PackedScene) var Wood
export (PackedScene) var Iron

var spawn_area
var spawn_center
var rand_position = Vector2(0, 0)


func _process(delta):
	if Input.is_action_just_pressed("arrow"):
		emit_signal("resource_dropped", 2, 3)

func _on_TestResourceDrop_resource_dropped(amount1, amount2):
	spawn_center = $Slime/SpawnArea/CollisionShape2D.global_position
	spawn_area = $Slime/SpawnArea/CollisionShape2D.shape.extents
	rand_position.x = (randf() * spawn_area.x) - (spawn_area.x / 2) + spawn_center.x
	rand_position.y = (randf() * spawn_area.y) - (spawn_area.y / 2) + spawn_center.y
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
		
	