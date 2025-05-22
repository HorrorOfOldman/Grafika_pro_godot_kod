extends Node3D

@export var detection_radius := 5.0 # w metrach
@onready var hero: Node3D = get_node("/root/TestEsk/MovementTest/Hero")
var scene_changed := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if scene_changed:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not event.is_echo():
		var distance = global_position.distance_to(hero.global_position)
		if distance < detection_radius:
			scene_changed = true
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_file("res://Assety/scenes/exploration/exploration_demo_end.tscn")
