extends SubViewport

func _ready():
	Globals.game_controller = self

@rpc("any_peer", "call_local", "reliable")
func start_game():
	print("starting game lol")
	$"../../UI".visible = false
