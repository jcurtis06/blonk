extends MarginContainer

func _on_lobby_menu_on_activated():
	print("key: " + Globals.key)
	$VBoxContainer/MarginContainer2/LobbyCode.text = "Code: " + Globals.key
	
	if !Globals.hosting:
		$VBoxContainer/Buttons/Ready.visible = true
		$VBoxContainer/Buttons/Start.visible = false
	else:
		$VBoxContainer/Buttons/Ready.visible = true
		$VBoxContainer/Buttons/Start.visible = true

func _on_copy_pressed():
	DisplayServer.clipboard_set(Globals.key)

func _on_cancel_pressed():
	get_parent().goto.emit("StartMenu")

func _on_start_pressed():
	Globals.game_controller.start_game.rpc()
	get_parent().visible = false
