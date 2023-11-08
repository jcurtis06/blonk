extends Control

signal goto(new_menu: NodePath)
signal on_activated

@onready var target: Vector2 = position

func _process(delta) -> void:
	if position.distance_to(target) > 0.1:
		position = position.lerp(target, 0.1)
	
	visible = position.x < 1150
