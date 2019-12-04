extends Control

func _ready():
	pass

func _on_Player_level_up(value):
	$HBoxContainer/Level.text = str("Level: ", value)

func _on_Player_damage_taken(value):
	$HBoxContainer/HBoxContainer/Health.text = str("Health: ", value)
