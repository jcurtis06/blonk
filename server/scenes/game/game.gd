extends Node3D

func start():
	print("Starting game...")
	
	for pid in multiplayer.get_peers():
		var player = preload("res://scenes/player/player.tscn").instantiate()
		player.name = str(pid)
		add_child(player)
		print("adding player for " + str(pid))
