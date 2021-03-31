extends Spatial

var is_sitted = false

func _ready():
	idle()

func sit():
	$AnimationPlayer.play("Breathing")
	is_sitted = true

func wave():
	if not is_sitted:
		$AnimationPlayer.play("Waving")

func idle():
	if not is_sitted:
		$AnimationPlayer.play("Idle")
		$WaveTimer.start(randf()*5)

func _on_WaveTimer_timeout():
	if $AnimationPlayer.current_animation == "Idle":
		wave()
