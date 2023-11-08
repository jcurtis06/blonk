extends SubViewport

func _ready():
	Globals.game_controller = self

@rpc("any_peer", "call_local", "reliable")
func start_game():
	$"/root/Main/UI/LobbyMenu".goto.emit("PlayerMenu")
