extends Node2D

export (PackedScene) var Arrow

func _on_NeutralHood_shoot(pos, dir):
	print(dir)
	var a = Arrow.instance()
	a.start(pos, deg2rad(dir))
	add_child(a)
