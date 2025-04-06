extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# sets the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# Stores the x/y direction the player is trying to look in
var _look := Vector2.ZERO
# Stores the direction moves when attacking
var _attack_direction := Vector3.ZERO


@export var min_boundary: float = -60
@export var max_boundary: float = 10
@export var animation_decay: float = 20.0
@export var mouse_sensitivity: float = 0.00075
@export var attack_move_speed: float = 3.0

@onready var rig: Node3D = $RigPivot/Rig
@onready var horizontal_pivot: Node3D = $HorizontalPivot
@onready var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot
@onready var rig_pivot: Node3D = $RigPivot
@onready var attack_cast: RayCast3D = %AttackCast

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	frame_camera_rotation()


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	# var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var direction := get_movement_direction()
	rig.update_animation_tree(direction)
	handle_idle_physics_frame(delta, direction)
	handle_slashing_physics_frame(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_look = - event.relative * mouse_sensitivity
	if rig.is_idle():
		if event.is_action_pressed("click"):
			slash_attack()

func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input_vector := Vector3(input_dir.x, 0, input_dir.y).normalized()
	return horizontal_pivot.transform.basis * input_vector

func frame_camera_rotation() -> void:
	horizontal_pivot.rotate_y(_look.x)
	vertical_pivot.rotate_x(_look.y)
	vertical_pivot.rotation.x = clamp(
		vertical_pivot.rotation.x,
		deg_to_rad(min_boundary),
		deg_to_rad(max_boundary)
	)
	$SmoothCameraArm.global_transform = vertical_pivot.global_transform
	_look = Vector2.ZERO

func look_toward_direction(direction: Vector3, delta: float) -> void:
	var target_transform := rig_pivot.global_transform.looking_at(
		rig_pivot.global_position + direction, Vector3.UP, true
	)
	rig_pivot.global_transform = rig_pivot.global_transform.interpolate_with(
		target_transform,
		1.0 - exp(-animation_decay * delta)
	)


func slash_attack() -> void:
	rig.travel("Slash")
	_attack_direction = get_movement_direction()
	if _attack_direction.is_zero_approx():
		_attack_direction = rig_pivot.global_basis * Vector3(0, 0, 1)
	attack_cast.clear_exceptions()

func handle_idle_physics_frame(delta: float, direction: Vector3) -> void:
	if not rig.is_idle():
		return
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		look_toward_direction(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func handle_slashing_physics_frame(delta: float) -> void:
	if not rig.is_slashing():
		return
	velocity.x = _attack_direction.x * attack_move_speed
	velocity.z = _attack_direction.z * attack_move_speed
	look_toward_direction(_attack_direction, delta)
	attack_cast.deal_damage()
