extends Node2D

export (PackedScene) var Arrow

var resources = {
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

func _on_NeutralHood_shoot(pos, dir):
	var a = Arrow.instance()
	a.start(pos, deg2rad(dir))
	add_child(a)


func _on_WoodCollectible_body_entered(body):
	print(body)
