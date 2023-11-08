# This node handles synchronizng properties controlled **BY THE SERVER**

extends MultiplayerSynchronizer

func _enter_tree():
	set_multiplayer_authority(1, false)
