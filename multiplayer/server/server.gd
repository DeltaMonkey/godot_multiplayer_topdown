# Bu script Project settings üzerinden autoload olarak belirlenmiştir.

extends Node

# sunucunun id si gerekiyor
const DEFAULT_IP = "127.0.0.1"
# sunucuya bağlanılacak port
const DEFAULT_PORT = 3234

			  # "PacketPeer implementation using the ENet library." hazır kütüphaneden network objesi açıyoruz
var network = NetworkedMultiplayerENet.new()

var selected_ip
var selected_port

var local_player_id = 0
sync var players = {}
sync var player_data = {}

func _ready():
	# sistem tarafından tanımlanmış signallere custom operasyonlar tanımlıyoruz
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _connect_to_server():
	# bu method proje başladığında game node lardan biri tarafından çağırılmalıdır
	
	print("connect operation")
	# önceden tanımlanmış connected_to_server sinyaline custom _connected_ok methodu ile bağlanıyoruz
	get_tree().connect("connected_to_server", self, "_connected_ok")
	
	# master tarafından yönetilecek olan client objesini oluşturuyoruz
	network.create_client(selected_ip, selected_port)
	# master(sunucu) ya ağ üzerinden client'ı bağlıyoruz
	get_tree().set_network_peer(network)
	
func _player_connected(id):
	print("Player: " + str(id) + " Connected")
	
func _player_disconnected(id):
	print("Player: " + str(id) + " Disconnected")
	
func _connected_ok():
	print("Successfully connected to server")
	register_player()
	rpc_id(1, "send_player_info", local_player_id, player_data)
	
func _connected_fail():
	print("Failed to connect")
	
func _server_disconnected():
	print("Server Disconnected")

func register_player():
	local_player_id = get_tree().get_network_unique_id();
	player_data = Save.save_data
	players[local_player_id] = player_data
	
sync func update_waiting_room():
	print("update waiting room çalıştı")
	get_tree().call_group("WaitingRoom", "refresh_players", players)
	
func load_game():
	rpc_id(1, "load_world")
	
sync func start_game():
	var world = preload("res://world/world.tscn").instance()
	get_tree().get_root().add_child(world);
	get_tree().get_root().get_node("Lobby").queue_free()
