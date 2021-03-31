extends Node

const SERVER_PORT = 35516
const SERVER_IP = "50.21.182.27"
var connected = false

func _ready():
	start_client()

func start_client():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	
	var peer = NetworkedMultiplayerENet.new()
	peer.compression_mode = NetworkedMultiplayerENet.COMPRESS_ZLIB
#	peer.always_ordered = true
	var err = peer.create_client(SERVER_IP, SERVER_PORT)
	if err != OK:
		print("failed to create client!")
		return
	
	get_tree().set_network_peer(peer)
	
	print("connecting...")

func _connected_ok():
	print("connected ok")
	connected = true

func _connected_fail():
	print("failed to connect to server!")

func _server_disconnected():
	print("server disconnected")
