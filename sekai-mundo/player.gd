extends Camera3D

@export var speed = 5.0
@export var rotation_speed = 3.5
@export var canvas_bg_speed = 4

var current_bot
var transmission_received

@onready var bg: Sprite2D = $"../CanvasLayer/BG"
@onready var canvas_layer: CanvasLayer = $"../WorldEnvironmentBGLayer"
@onready var area_3d: Area3D = $Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if area_3d.has_overlapping_areas():
		current_bot = area_3d.get_overlapping_areas()[0] # If there is a bot nearby, make them the current bot
		
		# If the player accepts the transmission and doesn't already have one, get the string
		if Input.is_action_just_pressed("ui_accept") and !transmission_received:
			transmission_received = current_bot.get_parent().transmission
	
	# Even if player is not close to the same bot, dump the transmission
	if Input.is_action_just_pressed("ui_cancel"):
		transmission_received = null


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
