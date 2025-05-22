extends CanvasLayer

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().quit()
		#get_tree().change_scene_to_file("res://Assety/scenes/menu/start_menu.tscn")
