extends CharacterBody3D

@export var speed: float = 6.0
@export var jump_force: float = 4.5
var gravity: float = 9.8


func _ready():
	# Projedeki fizik yerçekimi değerini çekiyoruz
	gravity = float(ProjectSettings.get_setting("physics/3d/default_gravity"))


func _physics_process(delta):
	var input_vector = Vector3.ZERO

	# Karakterin ileri ve sağ yönlerini al
	var forward = -transform.basis.z
	var right = transform.basis.x

	# Inputları oku
	input_vector += forward * Input.get_action_strength("move_forward")
	input_vector -= forward * Input.get_action_strength("move_back")
	input_vector -= right * Input.get_action_strength("move_right")
	input_vector += right * Input.get_action_strength("move_left")

	# Normalize et (köşeden koşarken hız artmasın)
	input_vector = input_vector.normalized()

	# Yatay hareket
	velocity.x = input_vector.x * speed
	velocity.z = input_vector.z * speed

	# Yer çekimi
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Zıplama
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Hareketi uygula
	move_and_slide()
