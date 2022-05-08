extends Node

const SAVEGAME = "user://savegame.json"

var save_data = {}

func _ready():
	save_data = get_data()

func get_data():
	var file = File.new()
	
	if not file.file_exists(SAVEGAME):
		# dosya yoksa save_data yı setle sonra kaydet
		save_data = {"player_name": "unnamed"}
		save_game()

	# bu aşamada en kötü durumda unnamed olarak boş data yazılmış olacak
	file.open(SAVEGAME, File.READ)
	# datayı oku
	var content = file.get_as_text()
	# datayı jsona döndür ve save_data yı setle
	var data = parse_json(content)
	save_data = data # gereksiz setleme işlemi olabilir !
	file.close()
	return(data)
	
func save_game():
	var save_game = File.new()
	save_game.open(SAVEGAME, File.WRITE)
	
	# satıra json olarak save_data yı yaz
	save_game.store_line(to_json(save_data))
