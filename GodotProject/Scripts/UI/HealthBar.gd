extends Control

onready var health_bar = $HealthBar

func _on_Slime_updated_enemy_health(health):
	health_bar.value = health
