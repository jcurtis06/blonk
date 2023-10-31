extends Node3D

@onready var host_http := $HostHTTP
@onready var join_http := $JoinHTTP

var hosting := true

func _on_host_pressed():
	hosting = true
	host_http.request("http://127.0.0.1:25565/create_room")

func _on_join_pressed():
	hosting = false
	var room_key = $UI/MainMenu/PanelContainer/VBox/HBoxContainer/LineEdit.text
	join_http.request("http://127.0.0.1:25565/join_room", ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify({"key": room_key}))

func _on_start_game_pressed():
	start_game.rpc()

func _on_host_http_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json := JSON.new()
		var error = json.parse(body.get_string_from_utf8())

		if error == OK:
			var port = json.data["port"]
			var key = json.data["key"]
			print("PORT: " + str(port))
			print("KEY: " + key)
			DisplayServer.clipboard_set(key)
			_join_room(port, key)
	else:
		print("Failed to start server instance.")


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

func _join_room(port: int, key: String):
	print("attempting to join...")
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connection_failed.connect(
		func():
			print("Could not join, retrying...")
			await get_tree().create_timer(1).timeout
			_join_room(port, key)
	)
	
	multiplayer.connected_to_server.connect(
		func():
			print("welcome to " + key + " brave adventurer " + str(peer.get_unique_id()))
			send_data_to(1, {"key": key})
	)

func send_data_to(id, data):
	data_recieved.rpc_id(id, multiplayer.multiplayer_peer.get_unique_id(), data)

@rpc("call_remote", "any_peer")
func data_recieved(from_id, data: Dictionary):
	if from_id == 1 && data.has("key_accepted"):
		$UI/MainMenu.visible = false
		$UI/Lobby.visible = true

@rpc("any_peer", "call_local", "reliable")
func start_game():
	$UI.visible = false
