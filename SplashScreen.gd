extends Node2D

func _on_Timer_timeout():
	$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(0,0,0,1), 2.0, Tween.TRANS_SINE)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	get_tree().change_scene("res://ChooseVR.tscn")
