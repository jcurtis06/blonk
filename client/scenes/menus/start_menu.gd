extends MarginContainer

@onready var menu = get_parent()

func _on_multiplayer_pressed():
	menu.goto.emit("MultiplayerMenu")

func _on_settings_pressed():
	menu.goto.emit("Settings")

func _on_extras_pressed():
	menu.get_parent().visible = false

func _on_quit_pressed():
	get_tree().quit()
