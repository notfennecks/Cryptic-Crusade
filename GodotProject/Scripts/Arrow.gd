extends Area2D

export (int) var arrow_speed = 150
var velocity = Vector2()

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(arrow_speed, 0).rotated(dir)

func _process(delta):
	position += velocity * delta
