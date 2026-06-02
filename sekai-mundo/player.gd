extends Camera3D

signal player_made_a_choice(chose_yes: bool, transmission: String)

@export var speed = 5.0
@export var rotation_speed = 3.5
@export var canvas_bg_speed = 4

var current_bot
var transmission_received

@onready var bg: Sprite2D = $"UI/BG"
@onready var canvas_layer: CanvasLayer = $"../WorldEnvironmentBGLayer"
@onready var area_3d: Area3D = $Area3D
@onready var text_label: Control = $"../UI/Control".get_child(0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var botname
	botname = current_bot.get_parent().name if current_bot else null
	
	if area_3d.has_overlapping_areas():
		current_bot = area_3d.get_overlapping_areas()[0] # If there is a bot nearby, make them the current bot
		
		# If the player accepts the transmission and doesn't already have one, get the string
		if Input.is_action_just_pressed("ui_accept") and !transmission_received:
			transmission_received = current_bot.get_parent().transmission
			$"../UI/Control/Label2".text = "(Y) for Yes; (N) for No" if botname != "WelcomeBot" else "Press Enter To continue"
			$"../Timer".start()
		
		if Input.is_action_just_pressed("ui_accept") and transmission_received:
			transmission_received = current_bot.get_parent().transmission
			$"../UI/Control/Label2".text = "(Y) for Yes; (N) for No" if botname != "WelcomeBot" else "Press Enter To continue"
			$"../Timer".start()
		
		if Input.is_action_just_pressed("ui_accept") and transmission_received and current_bot.get_parent().name == "WelcomeBot" and text_label.text != "":
			current_bot.get_parent().ti += 1
			current_bot.get_parent().ti = clampi(current_bot.get_parent().ti, 0, current_bot.get_parent().transmission.size() - 1)
	else:
		current_bot = null
	
	# Even if player is not close to the same bot, dump the transmission
	if Input.is_action_just_pressed("ui_cancel"):
		transmission_received = null
		$"../UI/Control/Label2".visible = false
	
	if Input.is_action_just_pressed("respond_no") and transmission_received and botname != "WelcomeBot":
		player_made_a_choice.emit(false, transmission_received)
	elif Input.is_action_just_pressed("respond_yes") and transmission_received and botname != "WelcomeBot":
		player_made_a_choice.emit(true, transmission_received)
	
	
	if transmission_received:
		if botname != "WelcomeBot" and typeof(transmission_received) != typeof([]):
			text_label.text = transmission_received
		elif botname == "WelcomeBot":
			# Use transmission index to get message
			if current_bot:
				text_label.text = transmission_received[current_bot.get_parent().ti]
	else: 
		text_label.text = ""
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _physics_process(delta: float) -> void:
	var velocity: Vector3
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var turn_strength = Input.get_axis("ui_left", "ui_right")
	var move_strength = Input.get_axis("ui_up", "ui_down")
	
	rotate_y(-deg_to_rad(turn_strength * rotation_speed))
	#print(rotation)
	
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(0, 0, move_strength)).normalized()
	if direction:
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		velocity.z = move_toward(velocity.z, 0, speed * delta)
	
	position += velocity
	canvas_layer.offset.x += -(turn_strength * rotation_speed) * canvas_bg_speed
