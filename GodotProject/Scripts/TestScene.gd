extends Node2D

onready var bar = $ProgressBar
onready var character = $NeutralHood
export (PackedScene) var Arrow

func _ready():
#	bar._init(character.experience_required, character.experience_total)
	pass
	
func _on_NeutralHood_shoot(pos, dir):
	var a = Arrow.instance()
	a.start(pos, deg2rad(dir))
	add_child(a)

