extends CharacterBody3D

@export var speed = 500
@export var jump_vel = 4.5
@export var sensitivity = 0.001
@export var flashlight_on = true

var y_vel = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera := $Camera3D
@onready var sync := $MultiplayerSynchronizer

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	camera.current = is_multiplayer_authority()

func _physics_process(delta):
	$Camera3D/SpotLight3D.light_energy = int(flashlight_on)
	
	if !is_multiplayer_authority(): return
	var horizontal_velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").normalized() * speed * delta
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	
	if is_on_floor():
		y_vel = 0
		if Input.is_action_just_pressed("jump"):
			y_vel = jump_vel
	else:
		y_vel -= gravity * delta
	velocity.y = y_vel
	
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("flashlight_toggle"):
		flashlight_on = !flashlight_on

func _input(event):
	if !is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
