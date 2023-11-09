extends Control

@onready var join_http := $JoinHTTP
@onready var host_http := $HostHTTP

@export var host_ip = "localhost"

func _on_back_pressed():
	get_parent().goto.emit("StartMenu")

func _on_host_pressed():
	Globals.hosting = true
	
	# Send a request to the master server to create a room
	host_http.request("http://" + host_ip + ":25565/create_room")
	$VBoxContainer/Buttons/Host.text = "Loading..."

func _on_host_http_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json := JSON.new()
		var error = json.parse(body.get_string_from_utf8())

		if error == OK:
			# No error, get the port of the server instance and the lobby key
			var port = json.data["port"]
			var key = json.data["key"]
			print("PORT: " + str(port))
			print("KEY: " + key)
			
			# Copy key to clipboard
			DisplayServer.clipboard_set(key)
			
			# Join the room
			_join_room(port, key)
	else:
		print("Failed to start server instance.")

func _on_join_pressed():
	Globals.hosting = false
	var room_key = $VBoxContainer/Buttons/VBoxContainer/LineEdit.text
	
	# Send a request to the master server to join a room
	join_http.request(
		"http://" + host_ip + ":25565/join_room", 
		["Content-Type: application/json"], 
		HTTPClient.METHOD_POST, JSON.stringify({"key": room_key})
	)
	
	$VBoxContainer/Buttons/VBoxContainer/Join.text = "Loading..."

func _on_join_http_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json := JSON.new()
		var error = json.parse(body.get_string_from_utf8())
		if error == OK:
			var port = json.data["port"]
			var key = json.data["key"]
			_join_room(port, key)
	else:
		print("Failed to join room.")

# Handle joining a room
func _join_room(port: int, key: String):
	print("Attempting to join...")
	
	# Creates a peer on localhost
	# This should be changed once running on server
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(host_ip, port)
	multiplayer.multiplayer_peer = peer
	
	# Handle connection failure
	multiplayer.connection_failed.connect(
		func():
			print("Could not join, retrying...")
			await get_tree().create_timer(1).timeout
			_join_room(port, key)
	)
	
	# Handle connection success
	multiplayer.connected_to_server.connect(
		func():
			print("welcome to " + key + " brave adventurer " + str(peer.get_unique_id()))
			Globals.key = key
			$VBoxContainer/Buttons/Host.text = "Host Game"
			$VBoxContainer/Buttons/VBoxContainer/Join.text = "Join Game"
			get_parent().goto.emit("LobbyMenu")
	)
