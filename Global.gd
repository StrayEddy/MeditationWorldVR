extends Node

signal nb_players_per_room_updated

var is_man = false
var is_vr = true
var current_room = "Start"

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

var nb_players_earth = 0
var nb_players_water = 0
var nb_players_air = 0
var nb_players_fire = 0

func update_rooms(new_rooms):
	rooms = new_rooms
	update_nb_players_per_room()

func update_nb_players_per_room():
	nb_players_earth = 5 - rooms.earth.players.count(null)
	nb_players_water = 5 - rooms.water.players.count(null)
	nb_players_air = 5 - rooms.air.players.count(null)
	nb_players_fire = 5 - rooms.fire.players.count(null)
	emit_signal("nb_players_per_room_updated")

func get_current_players():
	var _id = get_tree().get_network_unique_id()
	var players
	match current_room:
		"Earth":
			players = rooms.earth.players
		"Water":
			players = rooms.water.players
		"Air":
			players = rooms.air.players
		"Fire":
			players = rooms.fire.players
		"Start":
			players = [null, null, null, null]
			
	var player_index = -1
	for i in players.size():
		if players[i] != null:
			if players[i].id == _id:
				player_index = i
				break
	if player_index != -1:
		players.remove(player_index)
	return players

func _notification(event):
	match(event):
		MainLoop.NOTIFICATION_APP_PAUSED:
			get_tree().get_nodes_in_group("Main")[0].change_to("Start")
		MainLoop.NOTIFICATION_APP_RESUMED:
			Network.start_client()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
