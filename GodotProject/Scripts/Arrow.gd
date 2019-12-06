extends Area2D

export (int) var arrow_speed = 150
var velocity = Vector2()

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(arrow_speed, 0).rotated(dir)

func _process(delta):
	position += velocity * delta

func _on_Arrow_body_entered(body):
	if body.name == "Environment":
		velocity = Vector2(0, 0)
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
	if body.name == "Slime":
		body.take_damage()
