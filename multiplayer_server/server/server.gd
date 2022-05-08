extends Node
			  # "PacketPeer implementation using the ENet library." hazır kütüphaneden network objesi açıyoruz
var network = NetworkedMultiplayerENet.new()
var port = 3234
var max_players = 4

var players = {}

var ready_players = 0

func _ready():
	start_server()

func start_server():
	
	# makinenin ip adresinde belirtilen portta, kullanıcı sayısına göre bir sunucu açıyoruz
	network.create_server(port, max_players)
	
	# açtığımız suncuyu, ağa dahil ediyoruz, root node server master olarak ayarlanır.
	get_tree().set_network_peer(network)
	
	# sistem tarafından tanımlanmış signallere custom operasyonlar tanımlıyoruz
	network.connect("peer_connected", self, "_player_connected")
	network.connect("peer_disconnected", self, "_player_disconnected")

	print("server started")
	
func _player_connected(player_id):
	print("Player: " + str(player_id) + " Connected")
	
func _player_disconnected(player_id):
	print("Player: " + str(player_id) + " Disconnected")

remote func send_player_info(id, player_data):
	players[id] = player_data
	rset("players", players)
	rpc("update_waiting_room")

remote func load_world():
	ready_players += 1;
	if players.size() >= 1 and ready_players >= players.size():
		rpc("start_game")
		var world = preload("res://world/world.tscn").instance()
		get_tree().get_root().add_child(world)
