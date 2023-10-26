extends Control
 
var multiplayer_peer = ENetMultiplayerPeer.new()

func _ready():
	multiplayer_peer.create_server(
		25565,
		10
	)
	
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(add_player_character)
	$Menu.visible = false

func add_player_character(peer_id):
	var player = preload("res://player.tscn").instantiate()
	player.name = str(peer_id)
	add_child(player)
