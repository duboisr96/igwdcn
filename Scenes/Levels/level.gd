extends Node3D


var root = get_tree()
@export var production_speed := 1.0
var production_min = .5
var production_max = 4
var health = 10
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("levels")  # Add to a global group
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	$SpeedLever.rotation.z = (($"GUI canvas/Lever Controls".rotate_val - 20) / (100 -20)*(-2.6)+1.3)
	production_speed = (($"GUI canvas/Lever Controls".rotate_val - 20) / (100 -20)*(production_max - production_min)+production_min)
	
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


func _on_bin_minus_one() -> void:
	health -= 1
	print(health, ' health remaining')


func _on_bin_plus_one() -> void:
	score += 1
	print(score, ' total score')
