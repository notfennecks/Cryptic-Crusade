extends Control

func _ready():
	pass

func _on_StartButton_pressed():
	$FadeTransition.show()
	$FadeTransition/AnimationPlayer.play("Fade")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene(Global.level1_1)
