extends Node3D

@export var spin_speed: float = 5.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(delta * spin_speed)
