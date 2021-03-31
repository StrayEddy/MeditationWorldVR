extends Spatial

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$OmniLight.light_energy = rand_range(1.7, 2.0)
