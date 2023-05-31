extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5



@onready var cam : Camera3D= $Camera3D

var mouse_sens = 0.3
var camera_anglev=0

var sens = 0.2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var animation_player = $AnimationPlayer


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	scale.y = 0.6
	if event is InputEventMouseMotion:
		var movement = event.relative
		cam.rotation.x += -deg_to_rad(movement.y * sens)
		cam.rotation.x = clamp(cam.rotation.x , deg_to_rad(-90), deg_to_rad(90))
		rotation.y += -deg_to_rad(movement.x * sens)
	

func _physics_process(delta):
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if Input.is_action_just_pressed("swing"):
		animation_player.play("attack")
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func anim_finish():
	animation_player.play("idle")
