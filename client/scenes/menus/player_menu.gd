extends MarginContainer

func _process(delta):
	if Globals.seeker:
		$Role.text = "Role: Seeker"
	
	$Clock.text = "Survive " + str(round(Globals.game_controller.time_left))
