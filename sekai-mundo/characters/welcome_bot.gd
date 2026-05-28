extends Node3D

@export var rotation_speed = 1.5
var player_is_nearby: bool = false

func _ready() -> void:
	$Area3D.area_entered.connect(area_entered)
	$Area3D.area_exited.connect(area_exited)


func _process(delta: float) -> void:
	if player_is_nearby:
		rotate_y(rotation_speed * delta)


func area_entered(_area: Area3D) -> void:
	player_is_nearby = true


func area_exited(_area: Area3D) -> void:
	player_is_nearby = false
