extends Node3D # lub MeshInstance3D, jeśli to mesh

@export var rotation_speed : float = 5.0 # obrót w stopniach na sekundę

func _process(delta):
	rotate_y(deg_to_rad(-rotation_speed * delta))
