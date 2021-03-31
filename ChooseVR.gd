extends Node2D

func _ready():
	$AudioStreamPlayer.connect("finished", self, "audio_finished")

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			$AudioStreamPlayer.play()
			Global.is_vr = (event.position.x > 1440)

func audio_finished():
	get_tree().change_scene("res://ChooseGender.tscn")
