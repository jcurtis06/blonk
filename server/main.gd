extends Control
 
var multiplayer_peer = ENetMultiplayerPeer.new()

func _ready():
	multiplayer_peer.create_server(
		25565,
		10
	)
	
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(add_player_character)
	multiplayer_peer.peer_disconnected.connect(remove_player)
	$Menu.visible = false

func add_player_character(peer_id):
	var player = preload("res://player.tscn").instantiate()
	player.name = str(peer_id)
	add_child(player)

func remove_player(peer_id):
	get_node(str(peer_id)).queue_free()
