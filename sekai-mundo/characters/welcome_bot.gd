extends Node3D

@export var rotation_speed = 1.5
var player_is_nearby: bool = false

var transmission = [
	"Hello and welcome to our planet. We are happy to have you here.",
	"Our people have recently been gifted an amazing update for our robotic bodies.",
	"Unfortunately, this update doesn't work for all of us and it makes some of us function poorly.",
	"As a result, every bot on our planet is divided on what to do.",
	"We need your help stranger to help us come to a decision.",
	"Knowing the situation, do you think that every bot should go green even if that means some bots just won't work anymore?",
	"Or do you think that every bot should stay true blue, even though some bots could really benefit from the update?",
	"Whatever you decide, give your suggestion to the satellite bots behind me.",
	"The green bots of our group are not affiliated with any particular party",
	"Our job here is to help relay the message from the bots on the surface of the planet",
	"Please help us decide."
]
var ti = 0

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


func _on_timer_timeout() -> void:
	if name == "WelcomeBot":
		$"../UI/Control/Label2".visible = true
