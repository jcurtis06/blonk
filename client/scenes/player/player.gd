extends CharacterBody3D

@export var speed = 500
@export var jump_vel = 4.5
@export var sensitivity = 0.01
@export var flashlight_on = true
@export var seeker = false
@export var debug = false

@onready var camera := $Camera3D
@onready var sync := $MultiplayerSynchronizer
@onready var flashlight_energy = $Camera3D/SpotLight3D.light_energy

var y_vel = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Authority must be set before ready
func _enter_tree():
	if debug: return
	set_multiplayer_authority(str(name).to_int())

# Camera setup after authority is decided
func _ready():
	# The seeker variable is controlled by the server
	# See ServerAuthority child
	if seeker:
		$SeekerLabel.visible = true
	else:
		$HiderLabel.visible = true
	
	if !is_multiplayer_authority() && !debug: return
	camera.current = true
	Globals.seeker = seeker

# Movement & flashlight
func _physics_process(delta):
	# The flashlight_on variable is controlled only by the authority
	# We can update the light_energy every frame, regardless of authority
	$Camera3D/SpotLight3D.light_energy = int(flashlight_on) * flashlight_energy
	
	if !is_multiplayer_authority() && !debug: return
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
#
	if !velocity.is_zero_approx():
		if $AudioStreamPlayer.playing == false:
			$AudioStreamPlayer.play()
	else:
		if $AudioStreamPlayer.playing == true:
			$AudioStreamPlayer.play()

# Camera rotation
func _input(event):
	if !is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
