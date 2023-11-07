extends Node

@export var flashlight_on = true

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
