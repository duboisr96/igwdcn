class_name Shape
extends RigidBody3D

##defne sprite using code

@export var create_shape := ''
@export var create_color := ''
@export var create_velocity := Vector3.ZERO ##LETS SET IT TO AN ADDS TO 1 VALUE
var motion = Vector3.ZERO
var global_shape_velocity := 1.0
@export var expload_counter = 5.0
var current_count = 0.0
var belt_speed_multiplier := 1.0
var alive = true
#update png with filepath
var shape_dict := {
	"square" : preload("res://Scenes/objects/shapes/square.png"),
	"circle" : preload("res://Scenes/objects/shapes/circle.png"),
	"triangle" : preload("res://Scenes/objects/shapes/triangle.png"),
	"pentagon" : 'pentagon.png'
}
var on_belt := false

func _ready() -> void:
	add_to_group("grabbable")
	_bob()
	if create_shape == 'circle':
		#print('creating cirlce')
		_create_circle(create_color)
		pass
	
	elif create_shape == 'square':
		_create_square(create_color)
		#print('creating square')
	elif create_shape == 'triangle':
		_create_triangle(create_color)

func _physics_process(delta: float) -> void:
	if not on_belt and alive:
		current_count+= delta
	
	if (current_count >= expload_counter) and alive:
		#print('alive is ', alive)
		alive = false
		var node_level = get_tree().get_nodes_in_group("levels")
		node_level[0].shape_pop()
		$AudioStreamPlayer3D.play()
		hide()
		$Area3D/CollisionShape3D.disabled
		$CollisionShape3D.disabled
	
	#print(current_count)
		#print($".", " speed is ", motion, " position is ", position)
	_turn_to()
	_check_overlapping_areas()
	_check_speed(delta) #checks the speed of conveyor belt
	move_and_collide(motion)
	_show_shadow()


func _create_circle(color) -> void:
	#play noise
	$Sprite3D.set_texture(shape_dict['circle'])
	$Sprite3D.modulate = color
	#modulate
	pass
	
func _create_square(color) -> void:
	#play noise
	$Sprite3D.set_texture(shape_dict['square'])
	$Sprite3D.modulate = color
	#modulate
	pass
	
func _create_triangle(color) -> void:
	#play noise
	$Sprite3D.set_texture(shape_dict['triangle'])
	$Sprite3D.modulate = color
	#modulate
	pass

func _check_speed(delta) -> void:
	var parent = get_tree().get_nodes_in_group("levels")
	global_shape_velocity = parent[0].production_speed

	motion = create_velocity * delta * global_shape_velocity * int(on_belt)
	
	#get_tree() ##idk what its getting from tree yet but some global speed value? from uhhh.... the production machine?
	#UPDATE SPEED, VELOCITY IS THE SAME, NEED TO MULITPLY VELOCITY BY SPEED



func _on_body_entered(body: Node) -> void:

	pass # Replace with function body.

func _check_overlapping_areas() -> void:
	
	for area in $Area3D.get_overlapping_areas():
		#if area.name.begins_with("Bin"):
			#print(area.name)
			#print("collected a ", create_color, ' ', create_shape, " in a ",area.color, " ", area.shape, " bin!")
			#queue_free()
		if area.name.begins_with("recycle"):
			var sound = area.get_node('shred')
			sound.play()
			queue_free()
			#break
		#elif area.name == "Belt":  # Check if the area's name is "belt"
			#on_belt = true
			##for body in $".".get_colliding_bodies():
				##print('body')
				##if body.name == 'Belt':
					##$shadow.show()
					##break
			##print("On belt!")
			#break  # Exit loop early since we found a belt
		#else:
			##print('not on belt or in bin! DANGER')
			#on_belt = false
	#if $Area3D.get_overlapping_areas().is_empty():
		##print('not on belt or in bin! DANGER')
		#on_belt = false
	pass

func _turn_to() -> void:
	var camera = get_tree().get_current_scene().find_child("Camera3D", true, false)
	$Sprite3D.look_at(camera.global_position)

func _bob() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property($Sprite3D, 'position', Vector3(0,Vector3($Sprite3D.position).y + .05, 0 ), 1)
	tween.tween_property($Sprite3D, 'position', Vector3(0,Vector3($Sprite3D.position).y - .05, 0 ), 1)

func _show_shadow() -> void:
	if $Area3D/CollisionShape3D/RayCast3D.is_colliding():
		if ($Area3D/CollisionShape3D/RayCast3D.get_collider() != null):
			var area = $Area3D/CollisionShape3D/RayCast3D.get_collider()
			$shadow.show()
			#print(area.name)
			if area.name.begins_with('Belt'):
				on_belt = true
				create_velocity = area.belt_direction * create_velocity.length()
				#if area.belt_direction = 
		else:
			$shadow.hide()
	else:
		on_belt = false
		
func _que_three() -> void:
	queue_free()
