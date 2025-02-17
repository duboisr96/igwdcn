extends CharacterBody3D

#variables
@export var base_speed := 4.0
@export var sprint_speed := 8.0

var movement_input := Vector2.ZERO
var is_running := false
#settings
#@export var toggle_sprint := false

#jump variables from video https://www.youtube.com/watch?v=AoGOIiBo4Eg&ab_channel=ClearCode
@export var jump_height := 2.25
@export var jump_time_to_peak := 0.4
@export var jump_time_to_descent := 0.3
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1


#nodes
@onready var camera = $FollowingCameraController/Camera3D

#functions
func _physics_process(_delta) -> void:
	#Movement
	move_logic(_delta)
	jump_logic(_delta)
	move_and_slide()
	#Interact check
	if (Input.is_action_just_pressed("interact")):
		interact()


func interact() -> void:
	print("interact")
	
#handles horizontal movement
func move_logic(delta) -> void:
	movement_input = Input.get_vector("left","right","up", "down").rotated(-camera.global_rotation.y)
	#current horizontal velocity
	var horizontal_v = Vector2(velocity.x, velocity.z)
	
	#sprint speed
	is_running = Input.is_action_pressed("sprint")
	var speed = sprint_speed if is_running else base_speed

	if (movement_input != Vector2.ZERO):
		#Acceleration with input
		horizontal_v += movement_input * speed * delta
		horizontal_v = horizontal_v.limit_length(speed)
	else:
		#Deceleration without input kind of slides right now
		horizontal_v = horizontal_v.move_toward(Vector2.ZERO, base_speed * 4.0 * delta)
	velocity.x = horizontal_v.x
	velocity.z = horizontal_v.y
	
func jump_logic(delta) -> void:
	#handles vertical movement
	if is_on_floor():
		if (Input.is_action_pressed("jump")):
			velocity.y = -jump_velocity
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta
		
#Template 
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("left", "right", "up", "down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
