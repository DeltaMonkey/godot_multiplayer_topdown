extends Node2D

var PLAYER = preload("res://player/player.tscn")

onready var players = $players

remote func spawn_players(id):
	var player = PLAYER.instance()
	player.name = str(id)
	players.add_child(player)
	rpc("spawn_player", id)
