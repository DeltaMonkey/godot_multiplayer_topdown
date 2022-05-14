extends Node2D

const PLAYER = preload("res://player/player.tscn")
const ENEMY = preload("res://enemy/enemy.tscn")

var possible_destinations

onready var enemy_destinations = $enemy_spawn
onready var enemies = $enemies

onready var player_spawn = $player_spawn
onready var players = $players

func _ready():
	possible_destinations = enemy_destinations.get_children()
	rpc_id(1, "spawn_players", server.local_player_id)
	
remote func spawn_player(id):
	var player = PLAYER.instance()
	player.name = str(id)
	players.add_child(player)
	player.set_network_master(id)
	player.position = player_spawn.position
 
remote func spawn_enemy(idx, enemy_name):
	var new_destination = possible_destinations[idx]
	var enemy_instance = ENEMY.instance()
	enemy_instance.name = enemy_name
	enemies.add_child(enemy_instance)
	enemy_instance.position = new_destination.position


func _on_enemy_spawn_timer_timeout():
	rpc_id(1, "spawn_enemies")
