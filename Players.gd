extends Spatial

func _ready():
	sit_all()
	hide_all()
	
	Global.connect("nb_players_per_room_updated", self, "update")

func sit_all():
	$Player_0.sit()
	$Player_1.sit()
	$Player_2.sit()
	$Player_3.sit()

func hide_all():
	$Player_0.hide()
	$Player_1.hide()
	$Player_2.hide()
	$Player_3.hide()

func update():
	var players = Global.get_current_players()
	for index in players.size():
		var player = players[index]
		if player != null:
			show_player(index, player.is_man)
		else:
			hide_player(index)

func hide_player(index):
	match index:
		0:
			$Player_0.hide()
			$Player_0.mute()
		1:
			$Player_1.hide()
			$Player_1.mute()
		2:
			$Player_2.hide()
			$Player_2.mute()
		3:
			$Player_3.hide()
			$Player_3.mute()

func show_player(index, _is_man):
	match index:
		0:
			$Player_0.is_man(_is_man)
			$Player_0.show()
			$Player_0.unmute()
		1:
			$Player_1.is_man(_is_man)
			$Player_1.show()
			$Player_1.unmute()
		2:
			$Player_2.is_man(_is_man)
			$Player_2.show()
			$Player_2.unmute()
		3:
			$Player_3.is_man(_is_man)
			$Player_3.show()
			$Player_3.unmute()

func at_beach():
	$Player_0.translation = Vector3(3, 1.65, 26)
	$Player_0.rotation_degrees = Vector3(0, 90, 0)
	
	$Player_1.translation = Vector3(1, 1.6, 25)
	$Player_1.rotation_degrees = Vector3(0, 45, 0)
	
	$Player_2.translation = Vector3(1, 1.65, 23)
	$Player_2.rotation_degrees = Vector3(0, -45, 0)
	
	$Player_3.translation = Vector3(3, 1.65, 22)
	$Player_3.rotation_degrees = Vector3(0, -90, 0)
	
	refresh_icon_lookat()
	

func at_clearing():
	$Player_0.translation = Vector3(-16, 8, 2)
	$Player_0.rotation_degrees = Vector3(0, 90, 0)
	
	$Player_1.translation = Vector3(-18, 8, 1)
	$Player_1.rotation_degrees = Vector3(0, 45, 0)
	
	$Player_2.translation = Vector3(-18, 8, -1)
	$Player_2.rotation_degrees = Vector3(0, -45, 0)
	
	$Player_3.translation = Vector3(-16, 7.9, -2)
	$Player_3.rotation_degrees = Vector3(0, -90, 0)
	
	refresh_icon_lookat()

func at_peak():
	$Player_0.translation = Vector3(20, 4.35, 17)
	$Player_0.rotation_degrees = Vector3(0, 90, 0)
	
	$Player_1.translation = Vector3(18, 4.35, 16)
	$Player_1.rotation_degrees = Vector3(0, 45, 0)
	
	$Player_2.translation = Vector3(18, 4.25, 14)
	$Player_2.rotation_degrees = Vector3(0, -45, 0)
	
	$Player_3.translation = Vector3(20, 4.15, 13)
	$Player_3.rotation_degrees = Vector3(0, -90, 0)
	
	refresh_icon_lookat()

func at_dock():
	$Player_0.translation = Vector3(-5, .7, -33)
	$Player_0.rotation_degrees = Vector3(0, 180, 0)
	
	$Player_1.translation = Vector3(-4, .75, -34)
	$Player_1.rotation_degrees = Vector3(0, 180, 0)
	
	$Player_2.translation = Vector3(-4, .75, -36)
	$Player_2.rotation_degrees = Vector3(0, 180, 0)
	
	$Player_3.translation = Vector3(-5, .75, -37)
	$Player_3.rotation_degrees = Vector3(0, 180, 0)
	
	refresh_icon_lookat()

func refresh_icon_lookat():
	var camera = get_tree().get_nodes_in_group("Camera")[0]
	$Player_0/MeshInstance.look_at(camera.global_transform.origin, Vector3.UP)
	$Player_0/MeshInstance.rotate_y(PI)
	$Player_1/MeshInstance.look_at(camera.global_transform.origin, Vector3.UP)
	$Player_1/MeshInstance.rotate_y(PI)
	$Player_2/MeshInstance.look_at(camera.global_transform.origin, Vector3.UP)
	$Player_2/MeshInstance.rotate_y(PI)
	$Player_3/MeshInstance.look_at(camera.global_transform.origin, Vector3.UP)
	$Player_3/MeshInstance.rotate_y(PI)
