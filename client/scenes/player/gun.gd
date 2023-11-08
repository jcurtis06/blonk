extends Node3D

@onready var raycast = $RayCast3D

func _process(delta):
	if !is_multiplayer_authority() || !Globals.seeker: return
	
	if Input.is_action_just_pressed("shoot"):
		$Gunshot.play()
		if raycast.is_colliding():
			var hit_player = raycast.get_collider()
			hit_player.receive_damage.rpc_id(hit_player.get_multiplayer_authority())
