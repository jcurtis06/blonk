extends SubViewport

@rpc("any_peer", "call_local", "reliable")
func start_game():
	print("Starting game...")
	
	# Slice the peers array
	var peers = multiplayer.get_peers()
	
	# Half will be seekers, the other half will be hiders
	Globals.seekers = peers.slice(0, floor(peers.size()/2))
	Globals.hiders = peers.slice(floor(peers.size()/2), peers.size())

	print("Seekers: " + str(Globals.seekers))
	print("Hiders: " + str(Globals.hiders))
	
	for pid in multiplayer.get_peers():
		var player = preload("res://scenes/player/player.tscn").instantiate()
		player.name = str(pid)
		
		if Globals.seekers.has(pid):
			player.seeker = true
		
		$Forest.add_child(player, true)
