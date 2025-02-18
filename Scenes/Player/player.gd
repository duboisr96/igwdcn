extends CharacterBody3D

#variables
@export var base_speed := 4.0
@export var sprint_speed := 8.0
var speed_modifier := 1.0

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

@onready var move_state_machine = $AnimationTree.get('parameters/MoveStateMachine/playback')
#nodes
@onready var camera = $FollowingCameraController/Camera3D

#functions
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta) -> void:
	#Movement
	move_logic(_delta)
	jump_logic(_delta)
	move_and_slide()
	#Interact check
	interact()
	


func interact() -> void:
	var tween = create_tween()
	if Input.is_action_just_pressed("unlock mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if (Input.is_action_pressed("interact")):
		print("interact")
		tween.tween_property($AnimationTree, "parameters/GrabBlend/blend_amount", 1, .25 )
	else:
		tween.tween_property($AnimationTree, "parameters/GrabBlend/blend_amount", 0, .25 )
	
#handles horizontal movement
func move_logic(delta) -> void:
	movement_input = Input.get_vector("left", "right", "up", "down").rotated((-camera.global_rotation.y))
	#current horizontal velocity
	velocity = Vector3(movement_input.x,0,movement_input.y) * base_speed
	var horizontal_v = Vector2(velocity.x, velocity.z)
	var actual_speed = sprint_speed if Input.is_action_pressed("sprint") else base_speed
	#sprint speed
	var is_running: bool = Input.is_action_pressed("sprint")

	if (movement_input != Vector2.ZERO):
		#Acceleration with input
		horizontal_v += movement_input * actual_speed * delta
		horizontal_v = horizontal_v.limit_length(actual_speed)
		var target_angle = -movement_input.angle() + PI/2
		$man.rotation.y = rotate_toward($man.rotation.y, target_angle, delta*5) 
		move_state_machine.travel('Walk')
	else:
		#Deceleration without input kind of slides right now
		horizontal_v = horizontal_v.move_toward(Vector2.ZERO, base_speed * 4.0 * delta)
		velocity.x = horizontal_v.x
		velocity.z = horizontal_v.y
		move_state_machine.travel('Idle??')
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
