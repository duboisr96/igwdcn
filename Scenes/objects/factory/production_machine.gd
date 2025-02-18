extends StaticBody3D

const default_shape_array := ['circle', 'square', 'triangle']
const default_color_array := ['DEEP_SKY_BLUE', 'RED', 'GREEN']


@export var shape_scene: PackedScene
@export var default_shape_to_create : int
@export var default_color_to_create : int

@onready var shape_to_create = default_shape_array[default_shape_to_create]
@onready var color_to_create = default_color_array[default_color_to_create]

@export var default_velocity := Vector3(.5,0,0)
#@export var error_percentage := 0.0
@export var production_default := 3.0
@export var global_speed_multiplier := 1.0

var rand = randi_range(1.0,100.0)
@export var error_top := 99.0
var error_amount := 0.0




var error_log := []
#var make_shape
#var make_color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = production_default
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	pass


func _on_timer_timeout() -> void:
	print('timer timeout')
	var parent = get_tree().get_nodes_in_group("levels")
	if parent[0].production_speed != global_speed_multiplier:
		$Timer.stop()
		global_speed_multiplier = parent[0].production_speed
		update_timer()
		
	rand = randi_range(1.0,100.0)
	if rand <= error_top :
		print('creating ', color_to_create, ' ', shape_to_create,' from machine')
		_output_shape(default_shape_to_create, default_color_to_create)
		#shape_to_create = 'square'
		#color_to_create = 'DEEP_SKY_BLUE'
	else:
		_handle_error(rand)
	
	print($Timer.wait_time)

func _handle_error(error_val) -> void:
	if error_amount == 1:
		_output_shape(error_log[0], error_log[1])
		pass
	if error_amount == 0:
		if error_val % 2:
		###color and shape error###
			var error_shape = randi_range(0,2)
			while default_shape_to_create == error_shape:
				error_shape = randi_range(0,2)
			var error_color = randi_range(0,2)
			while default_color_to_create == error_color:
				error_color = randi_range(0,2)
			error_log.append(error_shape)
			error_log.append(error_color)
			print(error_log)
			error_amount += 1
			_output_shape(error_shape, error_color)
			#color and shape error
			#append to erroring
		elif error_val % 3:
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
