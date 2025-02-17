class_name Shape
extends RigidBody3D

##defne sprite using code

@export var create_shape := ''
@export var create_color := ''
@export var create_velocity := Vector3.ZERO ##LETS SET IT TO AN ADDS TO 1 VALUE
var motion = Vector3.ZERO
var global_shape_velocity := 1.0
#update png with filepath
var shape_dict := {
	"square" : 'square.png',
	"circle" : preload('res://icon.svg'),
	"tringle" : 'triangle.png',
	"pentagon" : 'pentagon.png'
}

func _ready() -> void:
	print('created!')
	if create_shape == 'circle':
		print('creating cirlce')
		_create_circle(create_color)
		pass
	
	elif create_shape == 'square':
		_create_square(create_color)
		
	elif create_shape == 'triangle':
		_create_triangle(create_color)

func _physics_process(delta: float) -> void:
	print($".", " speed is ", motion, " position is ", position)
	_check_speed(delta) #checks the speed of conveyor belt
	move_and_collide(motion)


func _create_circle(color) -> void:
	#play noise
	print("why no texture bug")
	$Sprite3D.set_texture(shape_dict['circle'])
	
	#modulate
	pass
	
func _create_square(color) -> void:
	#play noise
	#modulate
	pass
	
func _create_triangle(color) -> void:
	#play noise
	#modulate
	pass

func _check_speed(delta) -> void:
	motion = create_velocity * delta * global_shape_velocity
	get_tree() ##idk what its getting from tree yet but some global speed value? from uhhh.... the production machine?
	#UPDATE SPEED, VELOCITY IS THE SAME, NEED TO MULITPLY VELOCITY BY SPEED



func _on_body_entered(body: Node) -> void:
	#check if bin is for correct shape?
	pass # Replace with function body.
