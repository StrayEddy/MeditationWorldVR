extends Spatial

var spot = ""
var startenv
var beachenv
var clearingenv
var peakenv
var dockenv

var MOUSE_SENSITIVITY = 0.05

func _ready():
	OS.set_screen_orientation(OS.SCREEN_ORIENTATION_LANDSCAPE)
	if Global.is_vr:
		var VR = ARVRServer.find_interface("Native mobile")
		if VR and VR.initialize():
			get_viewport().arvr = true
			get_viewport().hdr = false
			
			OS.vsync_enabled = false
			Engine.target_fps = 90
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_viewport().warp_mouse(get_viewport().get_visible_rect().size*0.5)
	$VOIP.ask_server_for_rooms_info()
	$ARVROrigin.transform = $Start.transform
	$ARVROrigin/AnimationPlayer.connect("animation_finished", self, "arvrorigin_animation_finished")
	
	startenv = load("res://StartEnvironment.tres")
	beachenv = load("res://BeachEnvironment.tres")
	clearingenv = load("res://ClearingEnvironment.tres")
	peakenv = load("res://PeakEnvironment.tres")
	dockenv = load("res://DockEnvironment.tres")
	$WorldEnvironment.set_environment(startenv)

func _input(event):
	if event is InputEventMouseMotion:
		$ARVROrigin.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		$ARVROrigin/ARVRCamera.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))

func change_to(new_spot):
	if spot != "":
		$VOIP.leave_room(spot)
		match(spot):
			"Start":
				$Start.leave()
			"Beach":
				$Beach.leave()
			"Clearing":
				$Clearing.leave()
			"Dock":
				$Dock.leave()
			"Peak":
				$Peak.leave()
	if new_spot != "Start":
		$VOIP.join_room(new_spot)
	spot = new_spot
	
	$ARVROrigin/AnimationPlayer.play("fade_out")
	$Tween.interpolate_method(self, "set_master_volume", 0, -80, 1, Tween.TRANS_SINE, Tween.EASE_IN, 0)
	$Tween.start()

func arvrorigin_animation_finished(anim_name):
	if anim_name == "fade_out":
		$ARVROrigin/ARVRCamera.clear_current(false)
		end_fade_out()

func end_fade_out():
	var new_env = null
	match(spot):
		"Start":
			$ARVROrigin.transform = $Start.transform
			ARVRServer.center_on_hmd(ARVRServer.RESET_BUT_KEEP_TILT, true)
			new_env = startenv
			$Start.enter()
			$Players.sit_all()
			$Players.hide_all()
			$VOIP.ask_server_for_rooms_info()
			
			if not Global.is_vr:
				$ARVROrigin.translate(Vector3.UP * 2.0)
			
		"Beach":
			$ARVROrigin.transform = $Beach.transform
			$ARVROrigin.translation += Vector3(0,-1,0)
			ARVRServer.center_on_hmd(ARVRServer.RESET_BUT_KEEP_TILT, true)
			new_env = beachenv
			$Beach.enter()
			$Players.at_beach()
			
			if not Global.is_vr:
				$ARVROrigin.translate(Vector3.UP * 2.0)
			
		"Clearing":
			$ARVROrigin.transform = $Clearing.transform
			$ARVROrigin.translation += Vector3(0,-1,0)
			ARVRServer.center_on_hmd(ARVRServer.RESET_BUT_KEEP_TILT, true)
			new_env = clearingenv
			$Clearing.enter()
			$Players.at_clearing()
			
			if not Global.is_vr:
				$ARVROrigin.translate(Vector3.UP * 2.0)
		"Dock":
			$ARVROrigin.transform = $Dock.transform
			$ARVROrigin.translation += Vector3(0,-1,0)
			ARVRServer.center_on_hmd(ARVRServer.RESET_BUT_KEEP_TILT, true)
			new_env = dockenv
			$Dock.enter()
			$Players.at_dock()
			
			if not Global.is_vr:
				$ARVROrigin.translate(Vector3.UP * 2.0)
		"Peak":
			$ARVROrigin.transform = $Peak.transform
			$ARVROrigin.translation += Vector3(0,-1,0)
			ARVRServer.center_on_hmd(ARVRServer.RESET_BUT_KEEP_TILT, true)
			new_env = peakenv
			$Peak.enter()
			$Players.at_peak()
			
			if not Global.is_vr:
				$ARVROrigin.translate(Vector3.UP * 2.0)
	
#	Change environment
	$WorldEnvironment.set_environment(new_env)
	
#	Volume fade in
	$Tween.interpolate_method(self, "set_master_volume", -80, 0, 1, Tween.TRANS_SINE, Tween.EASE_IN, 0)
	$Tween.start()
	
	$ARVROrigin/AnimationPlayer.play("fade_in")
	yield(get_tree().create_timer(0.2), "timeout")
	$ARVROrigin/ARVRCamera.set_current(true)

func set_master_volume(db):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
