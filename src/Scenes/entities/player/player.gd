extends CharacterBody3D

@onready var mouse: Node3D = $Mouse
@onready var animation_player: AnimationPlayer = $Mouse/AnimationPlayer

var speed = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("sprint"):
		speed = 10.0
	else:
		speed = 5.0

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		# Rotar solo sobre Y (sin inclinación), corrigiendo la dirección
		var target_yaw = atan2(direction.x, direction.z)  # Z como frente
		mouse.rotation.y = lerp_angle(mouse.rotation.y, target_yaw, delta * 10.0)

		if animation_player.current_animation != "walk":
			animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

		if animation_player.current_animation != "idle":
			animation_player.play("idle")

	move_and_slide()
