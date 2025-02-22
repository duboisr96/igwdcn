extends CharacterBody3D

#variables
@export var base_speed := 4.0
@export var sprint_speed := 8.0
var speed_modifier := 1.0

var movement_input := Vector2.ZERO
var is_running := false
var computer_on := false
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
var can_grab := true
var grabbable_obj : Node3D = null
var grabbed_object : Node3D = null
var pullable_obj : Node3D = null
var pulled_obj : Node3D = null
var interactable_obj : Node3D = null
var interacted_obj: Node3D = null

var am_holding := false
var am_pulling := false
var am_interacting := false
var can_rotate := true

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
	_hold_obj()
	_pinpad_open()
	_interacting()
	


func interact() -> void:
	var tween = create_tween()
	##this is unrelated to currently chillin here
	#if Input.is_action_just_pressed("unlock mouse"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("open_computer"):
		_grab(grabbable_obj)
	
	if (Input.is_action_pressed("interact") ):
		_grab(grabbable_obj)
		tween.tween_property($AnimationTree, "parameters/GrabBlend/blend_amount", 1, .1 )
	else:
		$FollowingCameraController.can_adjust = true
		can_rotate = true
		tween.tween_property($AnimationTree, "parameters/GrabBlend/blend_amount", 0, .1 )
	
#handles horizontal movement
func move_logic(delta) -> void:
	movement_input = Input.get_vector("left", "right", "up", "down").rotated((-camera.global_rotation.y))
	#current horizontal velocity
	velocity = Vector3(movement_input.x,0,movement_input.y) * base_speed * speed_modifier
	var horizontal_v = Vector2(velocity.x, velocity.z)
	var actual_speed = sprint_speed if Input.is_action_pressed("sprint") else base_speed
	#sprint speed
	var is_running: bool = Input.is_action_pressed("sprint")

	if (movement_input != Vector2.ZERO):
		#Acceleration with input
		horizontal_v += movement_input * actual_speed * delta
		horizontal_v = horizontal_v.limit_length(actual_speed)
		if can_rotate:
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
	#if is_on_floor():
		#if (Input.is_action_pressed("jump")):
			#velocity.y = -jump_velocity
	#var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	#velocity.y -= gravity * delta
	pass

func _on_grab_area_body_entered(body: Node3D) -> void:
	if (body.is_in_group("grabbable") && !am_holding) or (body.is_in_group("pullable") && !am_holding) or (body.is_in_group("interactable") && !am_holding):
		
		##this can easily be cleaned up by making one obj and checking later for sure
		grabbable_obj = body
		#print('can be grabbed')
	#if (body.is_in_group("pullable") && !am_holding):
		#pullable_obj = body



func _on_grab_area_body_exited(body: Node3D) -> void:
	if body == grabbable_obj:
		grabbable_obj = null


func _grab(obj):
	if obj != null:
		if obj.is_in_group('grabbable'):
			grabbed_object = obj 
			grabbed_object.global_position = $man/GrabArea/CSGBox3D.global_position
			var col_shape = grabbed_object.get_node('CollisionShape3D')
			col_shape.disabled = true
			am_holding = true  
		elif obj.is_in_group('pullable'):
			#print('pullable')
			$FollowingCameraController.can_adjust = false
			pulled_obj = obj
			can_rotate = false
			speed_modifier = 0
		elif obj.is_in_group('interactable'):
			$FollowingCameraController.can_adjust = false
			interacted_obj = obj
			can_rotate = false
			speed_modifier = 0
		
		
			#update rotation with mouse movement
			
			#print('pulling')


func _hold_obj()  -> void:
	
	if grabbed_object != null and Input.is_action_pressed("interact") and am_holding:  # Replace "interact" with your actual input action
		var shadow = grabbed_object.get_node('shadow')
		grabbed_object.global_position = $man/GrabArea/CSGBox3D.global_position
		am_holding = true
		shadow.hide()
	elif grabbed_object != null and not Input.is_action_pressed("interact"):
		var shadow = grabbed_object.get_node('shadow')
		var col_shape = grabbed_object.get_node('CollisionShape3D')
		col_shape.disabled = false
		grabbed_object = null  # Release the object when the button is released
		am_holding = false
		shadow.show()
	else:
		am_holding = false
	
func _interacting()  -> void:
	#print(pulled_obj)
	
	if pulled_obj != null and Input.is_action_pressed("interact") and !am_interacting :
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN )
		speed_modifier = 0
		var gui_target = get_tree().get_nodes_in_group("control")
		#print(gui_target)
		if gui_target[0].name == 'Lever Controls':
			gui_target[0].show()
			#gui_target[0].grab_focus()
			gui_target[0].MOUSE_FILTER_STOP
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	elif pulled_obj != null:
		var gui_target = get_tree().get_nodes_in_group("control")
		if gui_target[0].name == 'Lever Controls':
			gui_target[0].hide()
			#gui_target[0].grab_focus()
			pulled_obj = null
			gui_target[0].MOUSE_FILTER_IGNORE
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		speed_modifier = 1

func _pinpad_open() -> void:

	if interacted_obj != null and Input.is_action_just_pressed("open_computer") and !computer_on:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		speed_modifier = 0
		computer_on = true
		var gui_target = get_tree().get_nodes_in_group("control")
		#print(gui_target)
		if interacted_obj.name.find('1') != -1:
			if gui_target[1].name == 'pinpad1':
				#print('opening pinpad')
				gui_target[1].show()
				#gui_target[0].grab_focus()
				gui_target[1].MOUSE_FILTER_STOP
		if interacted_obj.name.find('2') != -1:
			if gui_target[2].name == 'pinpad2':
				#print('opening pinpad')
				gui_target[2].show()
				#gui_target[0].grab_focus()
				gui_target[2].MOUSE_FILTER_STOP
		if interacted_obj.name.find('3') != -1:
			if gui_target[3].name == 'pinpad3':
				#print('opening pinpad')
				gui_target[3].show()
				#gui_target[0].grab_focus()
				gui_target[3].MOUSE_FILTER_STOP
	elif computer_on:
		#print('computer is on')
		if Input.is_action_just_pressed('open_computer'):
			print('close computer')
			computer_on = false
			var gui_target = get_tree().get_nodes_in_group("control")
			if interacted_obj.name.find('1') != -1:
				if gui_target[1].name == 'pinpad1':
					#print('opening pinpad')
					gui_target[1].hide()
					#gui_target[0].grab_focus()
					gui_target[1].MOUSE_FILTER_STOP
			if interacted_obj.name.find('2') != -1:
				if gui_target[2].name == 'pinpad2':
					#print('opening pinpad')
					gui_target[2].hide()
					#gui_target[0].grab_focus()
					gui_target[2].MOUSE_FILTER_STOP
			if interacted_obj.name.find('3') != -1:
				if gui_target[3].name == 'pinpad3':
					#print('opening pinpad')
					gui_target[3].hide()
					#gui_target[0].grab_focus()
					gui_target[3].MOUSE_FILTER_STOP
			
			
			
			
	elif interacted_obj != null:
		print('wrong loop')
		var gui_target = get_tree().get_nodes_in_group("control")
		if gui_target[1].name == 'pinpad1':
			gui_target[1].hide()
			#gui_target[0].grab_focus()
			interacted_obj = null
			gui_target[1].MOUSE_FILTER_IGNORE
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if gui_target[2].name == 'pinpad2':
			gui_target[2].hide()
			#gui_target[0].grab_focus()
			interacted_obj = null
			gui_target[2].MOUSE_FILTER_IGNORE
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if gui_target[3].name == 'pinpad3':
			gui_target[3].hide()
			#gui_target[0].grab_focus()
			interacted_obj = null
			gui_target[3].MOUSE_FILTER_IGNORE
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		speed_modifier = 1
	pass
