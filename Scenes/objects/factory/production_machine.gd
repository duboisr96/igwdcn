extends StaticBody3D

const default_shape_array := ['circle', 'square', 'triangle']
const default_color_array := ['0484b6', 'RED', 'GREEN']


@export var shape_scene: PackedScene
@export var default_shape_to_create : int
@export var default_color_to_create : int
signal error_occured
@onready var shape_to_create = default_shape_array[default_shape_to_create]
@onready var color_to_create = default_color_array[default_color_to_create]
@onready var circle = preload("res://Scenes/objects/shapes/circle.png")
@onready var square = preload("res://Scenes/objects/shapes/square.png")
@onready var triangle = preload("res://Scenes/objects/shapes/triangle.png")
@onready var png_array = [circle, square, triangle]



@export var default_velocity := Vector3(.5,0,0)
#@export var error_percentage := 0.0
@export var production_default := 3.0
@export var global_speed_multiplier := 1.0
@export var error_incriment := .25
@export var error_infection := 1.0
#@export var speed_infection := 0.2
var rand = randi_range(1.0,100.0)
@export var error_top := 99.0
var error_amount := 0.0
var temp_timer
var counter = 0
var counter_limit = 3 # per a standard 3 seconds it takes 432 to make on ryan pc
var not_spinning = true
var error_log := []
#var make_shape
#var make_color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite3D.texture = png_array[default_shape_to_create]
	$Sprite3D.modulate = default_color_array[default_color_to_create]
	$Timer.wait_time = production_default
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(global_speed_multiplier)
	#print(error_top)
	error_top = error_top - delta*error_incriment *global_speed_multiplier 
	var parent = get_tree().get_nodes_in_group("levels")
	#print($Timer.time_left)
	var how_fast = parent[0].production_speed
	counter += how_fast*delta
	#print($Timer.wait_time,'   ' , $Timer.time_left)
	
	if counter >= counter_limit:
		_on_timer_timeout()
	
	
	#if parent and parent[0].update_timer:
		#var old_speed = global_speed_multiplier
		#var new_speed = parent[0].production_speed
	
		#if old_speed != new_speed:
			#
			#global_speed_multiplier = new_speed
			#var elapsed_time = $Timer.wait_time - $Timer.time_left
			#var progress_ratio = elapsed_time / $Timer.wait_time
			#var new_wait_time = production_default / global_speed_multiplier
			#var new_time_left = new_wait_time * (1.0 - progress_ratio)
			#$Timer.stop()
			#$Timer.wait_time = new_time_left
			##print('new_time_left: ', new_time_left, ' new_wait_time: ', new_wait_time, ' progress_ratio: ', progress_ratio, ' elapsed_time:', elapsed_time)
			#$Timer.start()
	#if parent != null:
		#if parent[0].update_timer:
			#
			#temp_timer = $Timer.time_left
			#$Timer.stop()
			##print('UPDATING prod default: ', production_default, ' global speed is: ', global_speed_multiplier, ' temp timer is: ', temp_timer )
			##print(production_default / global_speed_multiplier , '  ', temp_timer * global_speed_multiplier)
			#print('temp timer:',temp_timer, '     prod speed:', parent[0].production_speed)
			#if parent[0].production_speed < global_speed_multiplier:
				#
				#$Timer.wait_time =  temp_timer / parent[0].production_speed
			#elif parent[0].production_speed > global_speed_multiplier:
				#$Timer.wait_time =  temp_timer * parent[0].production_speed
#
			#$Timer.start()
	#print($Timer.time_left)
	
	
	pass


func _on_timer_timeout() -> void:
	#print('timer timeout')
	#print(counter)
	counter = 0
	var parent = get_tree().get_nodes_in_group("levels")
	if parent[0].production_speed != global_speed_multiplier:
		$Timer.stop()
		global_speed_multiplier = parent[0].production_speed

	rand = randi_range(1.0,100.0)
	if rand <= error_top :
		#print('creating ', color_to_create, ' ', shape_to_create,' from machine')
		_output_shape(default_shape_to_create, default_color_to_create)
		#shape_to_create = 'square'
		#color_to_create = 'DEEP_SKY_BLUE'
	else:
		_handle_error(rand)
	
	#print($Timer.wait_time)

func _handle_error(error_val) -> void:
	#print('error')
	error_top -= error_infection
	error_occured.emit()
	$error_sound.play()
	#global_speed_multiplier += speed_infection
	#print('global speed ', global_speed_multiplier)
	var rando_spread := randi_range(1,10)
	if error_amount == 1:
		_output_shape(error_log[0], error_log[1])
		pass
	if error_amount == 0:
		if rando_spread <= 5:
		###color and shape error###
			var error_shape = randi_range(0,2)
			while default_shape_to_create == error_shape:
				error_shape = randi_range(0,2)
			var error_color = randi_range(0,2)
			while default_color_to_create == error_color:
				error_color = randi_range(0,2)
			error_log.append(error_shape)
			error_log.append(error_color)
			#print(error_log)
			error_amount += 1
			_output_shape(error_shape, error_color)
			#color and shape error
			#append to erroring
		elif rando_spread >5 && rando_spread <9:
			var error_color = randi_range(0,2)
			while default_color_to_create == error_color:
				error_color = randi_range(0,2)
			error_log.append(default_shape_to_create)
			error_log.append(error_color)
			error_amount = 1
			_output_shape(default_shape_to_create, error_color)
			#color error
			#append to erroring
			pass
		else:
			var error_shape = randi_range(0,2)
			while default_shape_to_create == error_shape:
				error_shape = randi_range(0,2)
			error_log.append(error_shape)
			error_log.append(default_color_to_create)
			error_amount += 1
			_output_shape(error_shape, default_color_to_create)
			#shape error
			#append
			pass
		
		pass

func _output_shape(shape_num, color_num) -> void:
	#print(error_top)
	#$steam.emitting = false
	#await get_tree().process_frame
	$OmniLight3D.light_energy = 2
	var tween = create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 0, .65 )
	$steam.emitting = true
	$create_sound.play()
	#$steam.emitting = true
	spin_lights()
	var new_shape = shape_scene.instantiate()
	new_shape.create_shape = default_shape_array[shape_num] #shape of product to be produced
	new_shape.create_color = default_color_array[color_num] #color of shape to be produced
	new_shape.create_velocity = default_velocity #DIRECTION OF PROD LINE
	add_child(new_shape)

func update_timer():
	$Timer.wait_time = production_default / global_speed_multiplier
	$Timer.start()


func _decrease_error() -> void:
	if error_top < 94:
		error_top += 5
		print('decreaing error, error total is ', 100 - error_top, '%')

func _increase_error() -> void:
	if error_top >=5:
		error_top -=5
		print('increasing error, error total is ', 100 - error_top, '%')
		
func check_error(code) -> void:
	#print('checking error')
	if code[0] == 'Start':
	
		#print(default_color_array[default_color_to_create])
		if code[1] == default_color_array[default_color_to_create]:
			
			if code[2] == default_shape_array[default_shape_to_create]:
				if not error_log.is_empty():
					if code[3] == default_color_array[error_log[1]]:
						if code[4] == default_shape_array[error_log[0]]:
							if code[5] == 'End':
								error_log.clear()
								$code_correct_sound.play()
								error_top = 99.0
								error_amount = 0
							else:
								error_top -=20
								$code_incorrect_sound.play()
						else:
							error_top -=20
							$code_incorrect_sound.play()
					else:
						error_top -=20
						$code_incorrect_sound.play()
				else:
					error_top -=20
					$code_incorrect_sound.play()
			else:
				error_top -=20
				$code_incorrect_sound.play()
		else:
			error_top -=20
			$code_incorrect_sound.play()
	else:
		error_top -=20
		$code_incorrect_sound.play()
	#print(code)
	pass
func spin_lights():
	print('spin')
	$SpotLight3D.light_energy = 0.0
	$SpotLight3D.show()
	var tween = create_tween()
	tween.tween_property($SpotLight3D, 'light_energy', 1.0, 1/global_speed_multiplier)
	await tween.finished
	$SpotLight3D.hide()
