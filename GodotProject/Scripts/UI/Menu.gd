extends Control

func _ready():
	OS.window_fullscreen = true
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if OS.window_fullscreen == true:
			OS.window_fullscreen = false
		else:
			OS.window_fullscreen = true

func _on_StartButton_pressed():
	$FadeTransition.show()
	$FadeTransition/AnimationPlayer.play("Fade")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene(Global.level1_1)

func _on_QuitButton_pressed():
	get_tree().quit()
