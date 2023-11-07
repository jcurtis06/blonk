extends Control
 
@onready var http = $HTTPRequest

# Holds the room key of this server
var room_key = ""

# Control the state of the game
var room_state := RoomState.IN_LOBBY

func _ready() -> void:
	print("Starting server...")
	
	# Read arguments that the server started with
	var arguments := {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value := argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
		else:
			arguments[argument.lstrip("--")] = ""
	
	# Get the port that the server should be started on
	if arguments.has("port"):
		var peer = ENetMultiplayerPeer.new()
		peer.create_server(int(arguments["port"]))
		multiplayer.multiplayer_peer = peer
		print("Created server on port " + str(arguments["port"]))
		
		# Listen for disconnections
		multiplayer.peer_disconnected.connect(
			func(pid: int) -> void:
				# Destroy the player's node if in game
				if room_state == RoomState.STARTED:
					if has_node(str(pid)):
						get_node(str(pid)).queue_free()
				
				# Quit the server if lobby is empty
				if multiplayer.get_peers().size() == 0:
					get_tree().quit()
		)
	
	# Get the room key that is required to login
	if arguments.has("key"):
		room_key = arguments["key"]

func add_player_character(peer_id):
	var player = preload("res://scenes/player/player.tscn").instantiate()
	player.name = str(peer_id)
	add_child(player)

func remove_player(peer_id):
	get_node(str(peer_id)).queue_free()

@rpc("any_peer", "call_local", "reliable")
func start_game():
	$Game.start()
