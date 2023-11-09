extends MarginContainer

func _on_rematch_pressed():
	Globals.game_controller.start_game.rpc()

func _on_exit_pressed():
	get_parent().goto.emit("MultiplayerMenu")
	multiplayer.multiplayer_peer.close()
