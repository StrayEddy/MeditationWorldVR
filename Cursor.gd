extends Spatial

signal click
var isStaring = false

func _input(event):  
	if event is InputEventScreenTouch and event.pressed:
		$AudioClick.play()
		var target = get_tree().get_nodes_in_group("Camera")[0].get_node("RayCast").get_collider()
		if target != null:
			emit_signal("click", target)

func start_staring():
	isStaring = true

func stop_staring():
	isStaring = false
