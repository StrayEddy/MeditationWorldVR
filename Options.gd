extends Spatial

var exit = false

var back_tex
var back_selected_tex
var bell_tex
var bell_selected_tex

var cursor_raycast
var can_start_raycast_check = false

func _ready():
	hide_options()
	get_tree().get_nodes_in_group("Cursor")[0].connect("click", self, "on_click")
	back_tex = load("res://images/options/back.png")
	back_selected_tex = load("res://images/options/back-selected.png")
	bell_tex = load("res://images/options/bell.png")
	bell_selected_tex = load("res://images/options/bell-selected.png")
	
	cursor_raycast = get_tree().get_nodes_in_group("Camera")[0].get_node("RayCast")
	yield(get_tree().create_timer(0.5), "timeout")
	can_start_raycast_check = true

func _process(delta):
	if can_start_raycast_check:
		var target = cursor_raycast.get_collider()
		staring_at(target)

func staring_at(target):
	if target == null:
		$Exit/MeshInstance.get_surface_material(0).albedo_texture = back_tex
		$Bell/MeshInstance.get_surface_material(0).albedo_texture = bell_tex
		return
	
	match(target.name):
		"Exit":
			$Exit/MeshInstance.get_surface_material(0).albedo_texture = back_selected_tex
			$Bell/MeshInstance.get_surface_material(0).albedo_texture = bell_tex
		"Bell":
			$Exit/MeshInstance.get_surface_material(0).albedo_texture = back_tex
			$Bell/MeshInstance.get_surface_material(0).albedo_texture = bell_selected_tex

func show_options():
	look_at(get_tree().get_nodes_in_group("Camera")[0].global_transform.origin, Vector3.UP)
	$Exit.set_collision_layer_bit(0, true)
	$Exit.set_collision_layer_bit(1, false)
	show()

func hide_options():
	$Exit.set_collision_layer_bit(0, false)
	$Exit.set_collision_layer_bit(1, true)
	$Bell/Audio.stop()
	print("stopped the bell")
	hide()

func on_click(target):
	match (target.name):
		"Exit":
			exit()
		"Bell":
			ring_bell()

func exit():
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().get_nodes_in_group("Main")[0].change_to("Start")

func ring_bell():
	$Bell/Audio.play()
