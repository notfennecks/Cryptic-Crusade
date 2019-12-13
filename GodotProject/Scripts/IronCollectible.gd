extends RigidBody2D

signal resource_collected(amount, type)

func _ready():
	connect("resource_collected", get_parent().get_node("Player"), "resource_collection")
	
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Tween.interpolate_property(self, "position", null, body.position, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
		$Tween.start()
		
func _on_Tween_tween_completed(object, key):
	emit_signal("resource_collected", 1, "Iron")
	queue_free()