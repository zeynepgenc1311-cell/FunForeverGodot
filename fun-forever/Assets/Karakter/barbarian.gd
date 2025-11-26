extends Node3D

@export var walk_speed = 5.0
@export var sprint_speed = 10.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.05  # düşük hassasiyet

var rotation_x = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Yön tuşları input
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		var speed = walk_speed
		if Input.is_action_pressed("ui_select"):  # shift sprint, istersen kaldırabilirsin
			speed = sprint_speed
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.z = move_toward(velocity.z, 0, walk_speed)

	# Zıplama
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _input(event):
	# Mouse ile kamera
	if event is InputEventMouseMotion:
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -45, 45)
		if has_node("SpringArm3D"):
			$SpringArm3D.rotation_degrees.x = rotation_x
		elif has_node("Camera3D"):
			$Camera3D.rotation_degrees.x = rotation_x
		rotation.y -= event.relative.x * mouse_sensitivity

func _unhandled_input(event):
	# ESC ile mouse serbest bırak
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
