extends ARVROrigin

var spot

func _on_Timer_timeout():
	if $ARVRCamera/RayCast.is_colliding() and not $ARVRCamera/Cursor.isStaring:
		$ARVRCamera/Cursor.start_staring()
	elif not $ARVRCamera/RayCast.is_colliding() and $ARVRCamera/Cursor.isStaring:
		$ARVRCamera/Cursor.stop_staring()
