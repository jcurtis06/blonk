extends Node3D

var multiplayer_peer = ENetMultiplayerPeer.new()

@onready var menu = $UI

@export var port = 25565
@export var address = "localhost"

func add_player(id=1):
	var character = preload("res://player.tscn").instantiate()
	character.name = str(id)
	add_child(character)

func _on_multiplayer_pressed():
	multiplayer_peer.create_client(address, port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
