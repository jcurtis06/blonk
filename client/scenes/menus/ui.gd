extends CanvasLayer

func _ready():
	for n in get_children():
		n.connect("goto",
			func(new_menu: NodePath):
				switch_to(n, get_node(new_menu))
		)

func switch_to(menu: Control, new_menu: Control) -> void:
	new_menu.target = Vector2(0, 0)
	new_menu.on_activated.emit()
	menu.target = Vector2(1152, 0)
