extends Spatial

var is_muted = false
var is_man = false

var muted_res = load("res://images/player/muted.png")
var unmuted_res = load("res://images/player/talking.png")

func _ready():
	get_tree().get_nodes_in_group("Cursor")[0].connect("click", self, "on_click")

func is_man(_is_man):
	is_man = _is_man
	if is_man:
		$Man.show()
		$Woman.hide()
	else:
		$Man.hide()
		$Woman.show()

func toggle_mute():
	is_muted = not is_muted
	if is_muted:
		mute()
	else:
		unmute()

func mute():
	$Audio.unit_db = -80
	$MeshInstance.duplicate()
	$MeshInstance.get_surface_material(0).albedo_texture = muted_res

func unmute():
	$Audio.unit_db = 10
	$MeshInstance.get_surface_material(0).albedo_texture = unmuted_res

func on_click(target):
	if target.get_parent().name == self.name:
		toggle_mute()

func sit():
	$Man.sit()
	$Woman.sit()
