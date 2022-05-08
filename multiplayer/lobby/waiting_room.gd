extends Popup

onready var player_list = $CenterContainer/VBoxContainer/itml_users

func _ready():
	player_list.clear()
	
func refresh_players(players):
	print("refresh_players çalıştı")
	player_list.clear()
	print(players)
	for player_id in players:
		var player = players[player_id]["player_name"]
		print(player)
		player_list.add_item(player, null, false)
