extends MarginContainer

func _process(delta):
	if Globals.seeker:
		$Role.text = "Role: Seeker"
