extends Node2D

var thread = null
var SIMULATED_DELAY_SEC = 1.0

func _ready():
	thread = Thread.new()
	thread.start(self, "_thread_load")
#	raise() # show on top

func _thread_load(args):
	var ril = ResourceLoader.load_interactive("res://Main.tscn")
	assert(ril)
	var total = ril.get_stage_count()
	$TextureProgress.max_value = total
	
	var res = null
	
	while true: #iterate until we have a resource
		# Update progress bar, use call deferred, which routes to main thread
		$TextureProgress.value = ril.get_stage()
		# Simulate a delay
		OS.delay_msec(SIMULATED_DELAY_SEC * 1000.0)
		# Poll (does a load step)
		var err = ril.poll()
		# if OK, then load another one. If EOF, it' s done. Otherwise there was an error.
		if err == ERR_FILE_EOF:
			# Loading done, fetch resource
			res = ril.get_resource()
			break
		elif err != OK:
			# Not OK, there was an error
			print("There was an error loading")
			break
	
	# Send whathever we did (or not) get
	call_deferred("_thread_done", res)

func _thread_done(resource):
	assert(resource)
	
	# Always wait for threads to finish, this is required on Windows
	thread.wait_to_finish()
	
	#Hide the progress bar
	$TextureProgress.hide()
	
	# Instantiate new scene
	var new_scene = resource.instance()
	# Add new one to root
	get_tree().root.add_child(new_scene)
	# Free VRNotice
	self.call_deferred("free")
