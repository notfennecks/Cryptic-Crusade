extends KinematicBody2D

var damage = 30

func _ready():
	$Bat/AnimationPlayer.play("Fly")

func _on_AreaDamage_body_entered(body):
	var target = body
	if target.name == "Player":
		target.update_health(damage)
