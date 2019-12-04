extends Control

var wood_item = "res://assets/Wood.png"

func _ready():
	$ItemList.add_item("Wood", null, false)
