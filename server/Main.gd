extends Node

const SERVER_PORT = 35516
const SERVER_IP = "50.21.182.27"
const MAX_PLAYERS = 20

func _ready():
	start_server()

func start_server():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	var peer = NetworkedMultiplayerENet.new()
	peer.compression_mode = NetworkedMultiplayerENet.COMPRESS_ZLIB
#	peer.always_ordered = true
	var err = peer.create_server(SERVER_PORT, MAX_PLAYERS)

	if err != OK:
		print("Failed to create server!")
		return
	
	get_tree().set_network_peer(peer)
	print("server started")

func _player_connected(_id):
	print("player with id: %s connected\n" % _id)
	$VOIP.send_rpc_rooms()

func _player_disconnected(_id):
	print("player with id: %s disconnected\n" % _id)
	$VOIP.leave_all_rooms(_id)
