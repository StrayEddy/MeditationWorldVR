extends Node

var rooms = {
	earth = {
		players = [null,null,null,null,null]
	},
	water = {
		players = [null,null,null,null,null]
	}, 
	air = {
		players = [null,null,null,null,null]
	}, 
	fire = {
		players = [null,null,null,null,null]
	}
}

func get_room(name):
	match name:
		"Earth":
			return rooms.earth.players
		"Water":
			return rooms.water.players
		"Air":
			return rooms.air.players
		"Fire":
			return rooms.fire.players
	return "Start"

func set_room(name, players):
	match name:
		"Earth":
			rooms.earth.players = players
		"Water":
			rooms.water.players = players
		"Air":
			rooms.air.players = players
		"Fire":
			rooms.fire.players = players

remote func server_join_room(_id, _is_man, _room):
	var players = get_room(_room)
	var null_index = players.find(null)
	if null_index != -1:
		print("Player %s has joined the %s room" % [_id, _room])
		var player = {
			id = _id,
			is_man = _is_man
		}
		players[null_index] = player
		set_room(_room, players)
		send_rpc_rooms()

remote func server_leave_room(_id, _room):
	if _room == "Start":
		return
	
	var players : Array = get_room(_room)
	var player_index = -1
	for i in players.size():
		if players[i] != null:
			if players[i].id == _id:
				player_index = i
				break
	if player_index != -1:
		print("Player %s has left the %s room" % [_id, _room])
		players[player_index] = null
		set_room(_room, players)
		send_rpc_rooms()

remote func server_request_rooms_info(_id):
	rpc_id(_id, "all_rooms_info_from_server", rooms)

func leave_all_rooms(player_id):
	server_leave_room(player_id, "Earth")
	server_leave_room(player_id, "Water")
	server_leave_room(player_id, "Air")
	server_leave_room(player_id, "Fire")

func send_rpc_rooms():
	rpc("all_rooms_info_from_server", rooms)
