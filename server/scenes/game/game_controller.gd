extends SubViewport

@export var time_left = 60.0
@export var hiders_remaining = 0

func _enter_tree():
	$GameSynchronizer.set_multiplayer_authority(1)

func _process(delta):
	if Globals.room_state != RoomState.STARTED: return
	if fmod($RoundTimer.time_left, 1.0) <= 0.05:
		time_left = $RoundTimer.time_left

func _on_round_timer_timeout():
	end_game.rpc(true)

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
	
	Globals.room_state = RoomState.STARTED
	$RoundTimer.start()

@rpc("any_peer", "call_remote")
func hider_dead(id: int) -> void:
	$Forest.get_node(str(id)).queue_free()
	Globals.hiders.remove_at(Globals.hiders.find(id))
	
	if Globals.hiders.size() <= 0:
		end_game.rpc(false)

@rpc("any_peer", "call_local")
func end_game(hiders_won: bool) -> void:
	print("game ended")
	for player in get_tree().get_nodes_in_group("Player"):
		print("freeing")
		player.queue_free()
