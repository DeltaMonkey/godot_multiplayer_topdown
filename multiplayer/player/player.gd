extends KinematicBody2D

const MAXSPEED = 500
const ACCELERATION = 300
const FRICTION = 200

var motion = Vector2.ZERO

onready var player_name_label = $lbl_player_name
onready var camera = $Camera2D

func _ready():
	player_name_label.set_as_toplevel(true)
	set_player_name()

func _physics_process(delta):
	if is_network_master():
		camera.current = true
		player_name_label.rect_position = Vector2(position.x - 40, position.y - 60)
		var input_vector = get_input_vector()
		# print(input_vector)
		apply_movement(input_vector, delta)
		apply_friction(input_vector, delta)
		motion = move_and_slide(motion)
		
		rpc_unreliable_id(1, "update_player", global_transform)
	
remote func update_remote_player(transform):
	if not is_network_master():
		global_transform = transform
		player_name_label.rect_position = Vector2(position.x - 40, position.y - 60)
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()

func apply_movement(input_vector, delta):
	look_at(get_global_mouse_position())
	if input_vector != Vector2.ZERO:
		motion = input_vector * MAXSPEED
	
func apply_friction(input_vector, delta):
	motion.x = lerp(motion.x, 0, pow(2, -50 * delta))
	motion.y = lerp(motion.y, 0, pow(2, -50 * delta))

func set_player_name():
	player_name_label.text = server.players[int(name)]["player_name"]
