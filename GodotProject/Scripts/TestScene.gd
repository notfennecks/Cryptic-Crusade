extends Node2D

onready var bar = $ProgressBar
onready var character = $NeutralHood
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

func _ready():
#	bar._init(character.experience_required, character.experience_total)
	pass
	

func _on_NeutralHood_shoot(pos, dir):
	var a = Arrow.instance()
	a.start(pos, deg2rad(dir))
	add_child(a)

func _on_WoodCollectible_body_entered(body):
	print(body)
