extends Node3D


var root = get_tree()
@export var production_speed := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("levels")  # Add to a global group
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("decrease error"):
		for child_node in $".".get_children():
			if child_node.name == 'ProductionMachine':
				child_node._decrease_error()
	if Input.is_action_just_pressed("increase error"):
		for child_node in $".".get_children():
			if child_node.name == 'ProductionMachine':
				child_node._increase_error()
	if Input.is_action_just_pressed("increase belt speed"):
		production_speed += .25
		print('belt speed is ', production_speed, ' mph')
	if Input.is_action_just_pressed("decrease belt speed"):
		if production_speed > .25: 
			production_speed -= .25
			print('belt speed is ', production_speed, ' mph')
