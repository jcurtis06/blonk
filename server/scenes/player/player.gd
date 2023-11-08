extends Node

@export var flashlight_on = true
@export var seeker = false

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
