extends Control

onready var player_name = $CenterContainer/VBoxContainer/GridContainer/txt_name
onready var selected_ip = $CenterContainer/VBoxContainer/GridContainer/txt_ip_address
onready var selected_port = $CenterContainer/VBoxContainer/GridContainer/txt_port
onready var waiting_room = $waiting_room
onready var btn_ready = $waiting_room/CenterContainer/VBoxContainer/btn_ready

func _ready():
	player_name.text = Save.save_data["player_name"]
	selected_ip.text = server.DEFAULT_IP
	selected_port.text = str(server.DEFAULT_PORT)
	
func _on_btn_join_pressed():
	server.selected_ip = selected_ip.text
	server.selected_port = int(selected_port.text)
	server._connect_to_server()
	show_waiting_room()

func _on_txt_name_text_changed(new_text):
	Save.save_data["player_name"] = new_text
	Save.save_game()
	
func show_waiting_room():
	waiting_room.popup_centered()

func _on_btn_ready_pressed():
	server.load_game()
	btn_ready.disabled = true
