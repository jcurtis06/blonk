extends Node

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
