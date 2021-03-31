extends Spatial

var fire_selected_tex
var fire_unselected_tex
var air_selected_tex
var air_unselected_tex
var water_selected_tex
var water_unselected_tex
var earth_selected_tex
var earth_unselected_tex

var nb_0_tex
var nb_1_tex
var nb_2_tex
var nb_3_tex
var nb_4_tex
var nb_5_tex

var cursor_raycast

var can_start_raycast_check = false

func _ready():
	fire_selected_tex = load("res://images/elements/fire-selected.png")
	fire_unselected_tex = load("res://images/elements/fire-unselected.png")
	air_selected_tex = load("res://images/elements/air-selected.png")
	air_unselected_tex = load("res://images/elements/air-unselected.png")
	water_selected_tex = load("res://images/elements/water-selected.png")
	water_unselected_tex = load("res://images/elements/water-unselected.png")
	earth_selected_tex = load("res://images/elements/earth-selected.png")
	earth_unselected_tex = load("res://images/elements/earth-unselected.png")
	
	nb_0_tex = load("res://images/elements/0.png")
	nb_1_tex = load("res://images/elements/1.png")
	nb_2_tex = load("res://images/elements/2.png")
	nb_3_tex = load("res://images/elements/3.png")
	nb_4_tex = load("res://images/elements/4.png")
	nb_5_tex = load("res://images/elements/5.png")
	
	cursor_raycast = get_tree().get_nodes_in_group("Camera")[0].get_node("RayCast")
	
	get_tree().get_nodes_in_group("Cursor")[0].connect("click", self, "on_click")
	Global.connect("nb_players_per_room_updated", self, "nb_players_per_room_updated")
	
	yield(get_tree().create_timer(0.5), "timeout")
	can_start_raycast_check = true

func _process(delta):
	if can_start_raycast_check:
		var target = cursor_raycast.get_collider()
		staring_at(target)

func on_click(target):	
	match(target.name):
		"Beach", "Dock", "Peak", "Clearing":
			get_tree().get_nodes_in_group("Main")[0].change_to(target.name)

func enter():
	$Audio.play()
	show_options()

func leave():
	$Audio.stop()
	hide_options()

func show_options():
	$Options/Beach.set_collision_layer_bit(0, true)
	$Options/Dock.set_collision_layer_bit(0, true)
	$Options/Peak.set_collision_layer_bit(0, true)
	$Options/Clearing.set_collision_layer_bit(0, true)
	
	$Options/Beach.set_collision_layer_bit(1, false)
	$Options/Dock.set_collision_layer_bit(1, false)
	$Options/Peak.set_collision_layer_bit(1, false)
	$Options/Clearing.set_collision_layer_bit(1, false)
	
	$Options.visible = true

func hide_options():
	$Options/Beach.set_collision_layer_bit(0, false)
	$Options/Dock.set_collision_layer_bit(0, false)
	$Options/Peak.set_collision_layer_bit(0, false)
	$Options/Clearing.set_collision_layer_bit(0, false)
	
	$Options/Beach.set_collision_layer_bit(1, true)
	$Options/Dock.set_collision_layer_bit(1, true)
	$Options/Peak.set_collision_layer_bit(1, true)
	$Options/Clearing.set_collision_layer_bit(1, true)
	
	$Options.visible = false

func staring_at(target):
	if target == null:
		$Options/Beach/MeshInstance.get_surface_material(0).albedo_texture = fire_unselected_tex
		$Options/Dock/MeshInstance.get_surface_material(0).albedo_texture = water_unselected_tex
		$Options/Peak/MeshInstance.get_surface_material(0).albedo_texture = air_unselected_tex
		$Options/Clearing/MeshInstance.get_surface_material(0).albedo_texture = earth_unselected_tex
		
		$Options/Beach/Number.get_surface_material(0).albedo_color = Color.white
		$Options/Dock/Number.get_surface_material(0).albedo_color = Color.white
		$Options/Peak/Number.get_surface_material(0).albedo_color = Color.white
		$Options/Clearing/Number.get_surface_material(0).albedo_color = Color.white
		return
	
	match(target.name):
		"Beach":
			$Options/Beach/MeshInstance.get_surface_material(0).albedo_texture = fire_selected_tex
			$Options/Dock/MeshInstance.get_surface_material(0).albedo_texture = water_unselected_tex
			$Options/Peak/MeshInstance.get_surface_material(0).albedo_texture = air_unselected_tex
			$Options/Clearing/MeshInstance.get_surface_material(0).albedo_texture = earth_unselected_tex
			
			$Options/Beach/Number.get_surface_material(0).albedo_color = Color("ffef972d")
			$Options/Dock/Number.get_surface_material(0).albedo_color = Color.white
			$Options/Peak/Number.get_surface_material(0).albedo_color = Color.white
			$Options/Clearing/Number.get_surface_material(0).albedo_color = Color.white
		"Dock":
			$Options/Beach/MeshInstance.get_surface_material(0).albedo_texture = fire_unselected_tex
			$Options/Dock/MeshInstance.get_surface_material(0).albedo_texture = water_selected_tex
			$Options/Peak/MeshInstance.get_surface_material(0).albedo_texture = air_unselected_tex
			$Options/Clearing/MeshInstance.get_surface_material(0).albedo_texture = earth_unselected_tex
			
			$Options/Beach/Number.get_surface_material(0).albedo_color = Color.white
			$Options/Dock/Number.get_surface_material(0).albedo_color = Color("ff5db5c8")
			$Options/Peak/Number.get_surface_material(0).albedo_color = Color.white
			$Options/Clearing/Number.get_surface_material(0).albedo_color = Color.white
		"Peak":
			$Options/Beach/MeshInstance.get_surface_material(0).albedo_texture = fire_unselected_tex
			$Options/Dock/MeshInstance.get_surface_material(0).albedo_texture = water_unselected_tex
			$Options/Peak/MeshInstance.get_surface_material(0).albedo_texture = air_selected_tex
			$Options/Clearing/MeshInstance.get_surface_material(0).albedo_texture = earth_unselected_tex
			
			$Options/Beach/Number.get_surface_material(0).albedo_color = Color.white
			$Options/Dock/Number.get_surface_material(0).albedo_color = Color.white
			$Options/Peak/Number.get_surface_material(0).albedo_color = Color("ffb798c8")
			$Options/Clearing/Number.get_surface_material(0).albedo_color = Color.white
		"Clearing":
			$Options/Beach/MeshInstance.get_surface_material(0).albedo_texture = fire_unselected_tex
			$Options/Dock/MeshInstance.get_surface_material(0).albedo_texture = water_unselected_tex
			$Options/Peak/MeshInstance.get_surface_material(0).albedo_texture = air_unselected_tex
			$Options/Clearing/MeshInstance.get_surface_material(0).albedo_texture = earth_selected_tex
			
			$Options/Beach/Number.get_surface_material(0).albedo_color = Color.white
			$Options/Dock/Number.get_surface_material(0).albedo_color = Color.white
			$Options/Peak/Number.get_surface_material(0).albedo_color = Color.white
			$Options/Clearing/Number.get_surface_material(0).albedo_color = Color("ffa5d455")

func nb_players_per_room_updated():
	print("nb of players per room has been updated")
	match Global.nb_players_air:
		0:
			$Options/Peak/Number.get_surface_material(0).albedo_texture = nb_0_tex
		1:
			$Options/Peak/Number.get_surface_material(0).albedo_texture = nb_1_tex
		2:
			$Options/Peak/Number.get_surface_material(0).albedo_texture = nb_2_tex
		3:
			$Options/Peak/Number.get_surface_material(0).albedo_texture = nb_3_tex
		4:
			$Options/Peak/Number.get_surface_material(0).albedo_texture = nb_4_tex
		5:
			$Options/Peak/Number.get_surface_material(0).albedo_texture = nb_5_tex
	
	match Global.nb_players_earth:
		0:
			$Options/Clearing/Number.get_surface_material(0).albedo_texture = nb_0_tex
		1:
			$Options/Clearing/Number.get_surface_material(0).albedo_texture = nb_1_tex
		2:
			$Options/Clearing/Number.get_surface_material(0).albedo_texture = nb_2_tex
		3:
			$Options/Clearing/Number.get_surface_material(0).albedo_texture = nb_3_tex
		4:
			$Options/Clearing/Number.get_surface_material(0).albedo_texture = nb_4_tex
		5:
			$Options/Clearing/Number.get_surface_material(0).albedo_texture = nb_5_tex
	
	match Global.nb_players_fire:
		0:
			$Options/Beach/Number.get_surface_material(0).albedo_texture = nb_0_tex
		1:
			$Options/Beach/Number.get_surface_material(0).albedo_texture = nb_1_tex
		2:
			$Options/Beach/Number.get_surface_material(0).albedo_texture = nb_2_tex
		3:
			$Options/Beach/Number.get_surface_material(0).albedo_texture = nb_3_tex
		4:
			$Options/Beach/Number.get_surface_material(0).albedo_texture = nb_4_tex
		5:
			$Options/Beach/Number.get_surface_material(0).albedo_texture = nb_5_tex
	
	match Global.nb_players_water:
		0:
			$Options/Dock/Number.get_surface_material(0).albedo_texture = nb_0_tex
		1:
			$Options/Dock/Number.get_surface_material(0).albedo_texture = nb_1_tex
		2:
			$Options/Dock/Number.get_surface_material(0).albedo_texture = nb_2_tex
		3:
			$Options/Dock/Number.get_surface_material(0).albedo_texture = nb_3_tex
		4:
			$Options/Dock/Number.get_surface_material(0).albedo_texture = nb_4_tex
		5:
			$Options/Dock/Number.get_surface_material(0).albedo_texture = nb_5_tex
