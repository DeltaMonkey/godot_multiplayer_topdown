extends Node2D

const PLAYER = preload("res://player/player.tscn")
onready var player_spawn = $player_spawn
onready var players = $players

func _ready():
	rpc_id(1, "spawn_players", server.local_player_id)
	
remote func spawn_player(id):
	var player = PLAYER.instance()
	player.name = str(id)
	players.add_child(player)
	player.set_network_master(id)
	player.position = player_spawn.position
 
