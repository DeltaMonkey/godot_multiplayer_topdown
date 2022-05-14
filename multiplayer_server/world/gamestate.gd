extends Node2D

var PLAYER = preload("res://player/player.tscn")
var ENEMY = preload("res://enemy/enemy.tscn")

var enemy_count = 0
var max_enemies = 5

onready var players = $players
onready var enemies = $enemies

remote func spawn_players(id):
	var player = PLAYER.instance()
	player.name = str(id)
	players.add_child(player)
	rpc("spawn_player", id)

remote func spawn_enemies():
	var enemy_instance = ENEMY.instance()
	var idx = randi() % 4
	enemy_instance.name = str(enemy_count)

	if enemy_count < max_enemies:
		enemy_count += 1
		enemies.add_child(enemy_instance)
		rpc("spawn_enemy", idx, enemy_instance.name)
