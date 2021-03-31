extends Node

const EMPTY_PLAYERS = [null, null, null, null]
const MIN_PACKET_SIZE = 10000

var mic : AudioEffectRecord
var record
var recording = false
var players = EMPTY_PLAYERS

func _ready():
	mic = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 0)
	mic.format = AudioStreamSample.FORMAT_IMA_ADPCM

remote func client_voice(_id, audioPacket, format, mix_rate, stereo):
	var player_index = -1
	for i in players.size():
		if players[i] != null:
			if players[i].id == _id:
				player_index = i
				break
	if player_index == -1:
		return
	
	var audioStream = AudioStreamSample.new()
	audioStream.data = audioPacket
	audioStream.set_format(format)
	audioStream.set_mix_rate(mix_rate)
	audioStream.set_stereo(stereo)
	
	var audio = get_node("../Players/Player_" + str(player_index)).get_node("Audio")
	audio.stream = audioStream
	audio.play()

func get_room_element_name(room_name):
	match room_name:
		"Beach":
			return "Fire"
		"Clearing":
			return "Earth"
		"Dock":
			return "Water"
		"Peak":
			return "Air"
	return "Start"

func join_room(_room):
	var room = get_room_element_name(_room)
	rpc_id(1,"server_join_room", get_tree().get_network_unique_id(), Global.is_man, room)
	Global.current_room = room

func leave_room(_room):
	var room = get_room_element_name(_room)
	rpc_id(1,"server_leave_room", get_tree().get_network_unique_id(), room)
	Global.current_room = "Start"

func _on_VOIPTimer_timeout():
	# do not record or send when no players around
	recording = not (players == EMPTY_PLAYERS)

	if Network.connected && recording:
		if mic.is_recording_active():
			record = mic.get_recording()
			if record.get_data().size() > MIN_PACKET_SIZE:
				mic.set_recording_active(false)
				for player in players:
					if player != null:
						rpc_unreliable_id(player.id, "client_voice",get_tree().get_network_unique_id(), record.get_data(), record.get_format(), record.get_mix_rate(), record.is_stereo())
				mic.set_recording_active(true)
		else:
			mic.set_recording_active(true)
	else:
		mic.set_recording_active(false)

func ask_server_for_rooms_info():
	rpc_id(1,"server_request_rooms_info", get_tree().get_network_unique_id())

# Called by the server to tell changes in rooms
remote func all_rooms_info_from_server(rooms):
	Global.update_rooms(rooms)
	players = Global.get_current_players()
