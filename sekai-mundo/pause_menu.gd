extends CanvasLayer

@onready var h_slider: HSlider = $ColorRect2/VBoxContainer/HSplitContainer/HSlider
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $'../Player/AudioStreamPlayer3D'


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	var bus = AudioServer.get_bus_index(&'Master')
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus))


# Runs only once per input received whereas process runs every frame
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true


func _on_back_button_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_h_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index(&'Master')
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	#audio_stream_player_3d.volume_db = value
