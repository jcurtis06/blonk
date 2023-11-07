extends SubViewport

@rpc("any_peer", "call_local", "reliable")
func start_game():
	print("Starting game...")
	
	for pid in multiplayer.get_peers():
		var player = preload("res://scenes/player/player.tscn").instantiate()
		player.name = str(pid)
		$Forest.add_child(player, true)
		print("adding player for " + str(pid))
