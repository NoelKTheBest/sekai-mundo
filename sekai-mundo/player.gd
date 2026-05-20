extends Camera3D

@export var speed = 5.0
@export var rotation_speed = 3.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var velocity: Vector3
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var turn_strength = Input.get_axis("ui_left", "ui_right")
	var move_strength = Input.get_axis("ui_up", "ui_down")
	
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(0, 0, move_strength)).normalized()
	if direction:
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		velocity.z = move_toward(velocity.z, 0, speed * delta)
	
	#print("x: ", velocity.x, "; z: ", velocity.z)
	position.z += velocity.z
	rotate_y(-deg_to_rad(turn_strength * rotation_speed))
	#deg_to_rad()
