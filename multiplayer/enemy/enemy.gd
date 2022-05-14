extends KinematicBody2D

const MAXSPEED = 80
const ACCELERATION = 300

var motion = Vector2.ZERO
var possible_players
var target_player

onready var players = get_tree().get_root().find_node("players", true, false)
onready var wrold = get_tree().get_root().get_node("world")

func _ready():
	possible_players = players.get_children()
	target_player = possible_players[0]

remote func select_player_target(idx):
	target_player = possible_players[idx]

func _physics_process(delta):
	var player_direction = (target_player.position - global_position).normalized()
	motion = player_direction * MAXSPEED
	motion = move_and_slide(motion)

func _on_player_dedection_body_entered(body):
	if body.is_in_group('Player'):
		target_player = body
