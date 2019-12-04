extends Control

func _ready():
	pass

func _on_StartButton_button_up():
	$Menu/Center/Buttons/Timer.start()

func _on_StartButton_button_down():
	$Faded.show()
	$Faded/AnimationPlayer.play("Fading")

func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/TestScene.tscn")

func _on_QuitButton_button_up():
	get_tree().quit()
