extends Spatial

func _ready():
	hide()

func enter():
	$Audio.play()
	show()
	match(name):
		"Beach":
			$Fireplace.show()
			$Fireplace/Audio.play()
			$Options.show_options()
		"Clearing":
			$Options.show_options()
		"Dock":
			$Options.show_options()
		"Peak":
			$Bowl.show()
			$Options.show_options()

func leave():
	$Audio.stop()
	hide()
	match(name):
		"Beach":
			$Fireplace.hide()
			$Fireplace/Audio.stop()
			$Options.hide_options()
		"Clearing":
			$Options.hide_options()
		"Dock":
			$Options.hide_options()
		"Peak":
			$Bowl.hide()
			$Options.hide_options()
