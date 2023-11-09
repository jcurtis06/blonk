extends SubViewport

@export var time_left = 0.0

func _enter_tree():
	$GameSynchronizer.set_multiplayer_authority(1)

func _ready():
	Globals.game_controller = self

@rpc("any_peer", "call_local", "reliable")
func start_game():
	if $"/root/Main/UI/LobbyMenu".visible == true:
		$"/root/Main/UI/LobbyMenu".goto.emit("PlayerMenu")
	else:
		$"/root/Main/UI/EndMenu".goto.emit("PlayerMenu")

@rpc("any_peer")
func end_game(hiders_won: bool) -> void:
	if hiders_won:
		print("Hiders have won!!!")
	else:
		print("Seekers have won!!!")
	
	$"/root/Main/UI/PlayerMenu".goto.emit("EndMenu")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

@rpc("any_peer", "call_remote")
func hider_dead(id: int) -> void:
	pass
