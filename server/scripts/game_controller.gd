extends Node

@export var remaining_time := 0.0

@onready var rt = $Timer

var state := GameState.LOBBY

var host := 0

var players: Array[int] = []
var seekers: Array[int] = []
var hiders: Array[int] = []
var spectators: Array[int] = []

var map_container: SubViewport

# ------------
# GAME OPTIONS
# ------------
var countdown := 5
var round_time := 60.0

# -----------------
# CONTROL FUNCTIONS
# -----------------
func _start_game() -> void:
	if multiplayer.get_peers().size() <= 0: return
	
	Lobby.announce("Starting countdown")
	
	countdown_started.rpc()

func _game_loop() -> void:
	remaining_time = rt.time_left
	
	if hiders.size() <= 0:
		round_ended.rpc(Cause.SEEKERS_WON)

func _process(delta: float) -> void:
	if state != GameState.IN_GAME: return
	_game_loop()

# -------------
# RPC FUNCTIONS
# -------------
@rpc("authority", "call_local")
func countdown_started() -> void:
	if countdown == 0:
		round_started.rpc()
		return
	
	state = GameState.COUNTDOWN
	
	get_tree().create_timer(countdown).timeout.connect(
		func():
			round_started.rpc()
	)

@rpc("authority", "call_local")
func round_started() -> void:
	var peers = Array(multiplayer.get_peers())

	peers.shuffle()
	
	seekers = peers.slice(0, floor(peers.size()/2))
	hiders = peers.slice(floor(peers.size()/2), peers.size())
	
	state = GameState.IN_GAME
	
	Lobby.announce("Game started!")
	Lobby.announce("Seekers: " + str(seekers))
	Lobby.announce("Hiders: " + str(hiders))
	
	rt.start(round_time)
	
	rt.timeout.connect(
		func() -> void:
			round_ended.rpc(Cause.HIDERS_WON)
	)

@rpc("authority", "call_local")
func round_ended(cause: Cause) -> void:
	state = GameState.END
	Lobby.announce("Round over! Cause: " + str(cause))

@rpc("any_peer")
func request_start_round(from_id: int, countdown: int = 5, round_time: float = 60.0) -> void:
	host = multiplayer.get_peers()[0]
	print("host: " + str(host))
	if from_id != host:
		Lobby.announce("Unable to start game! (INVALID HOST)")
		return
	_start_game()

@rpc("any_peer")
func player_dead(id: int) -> void:
	if hiders.has(id):
		map_container.get_node("Forest/" + str(id)).queue_free()
		hiders.erase(id)

@rpc("any_peer")
func attempt_event(event: Event) -> void:
	event.execute()
