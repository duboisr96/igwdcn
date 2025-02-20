extends Node3D


var root = get_tree()

@export var stage_time := 100
@export var production_speed := 1.0
@export var production_min = 1
@export var production_max = 4
@export var angle_min_rads = 1.3
@export var angle_max_rads = -1.3
@export var start_hour = 7
@export var end_hour = 15
@export var quota := 400


@onready var player_gui = $"GUI canvas/PlayerGUI"
var update_timer = false
##lever angle stuff
var input_min = 20
var input_max = 100


var health = 10
var quota_finished = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$StageTime.wait_time = stage_time
	$StageTime.start()
	add_to_group("levels")  # Add to a global group
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	_show_time()
	_rotate_lever()
	_keep_score()
	_manual_controls()



func _on_bin_minus_one() -> void:
	quota += 10
	#print('INCORRECT PRODUCT, ADDING TO QUOTA')

func _on_bin_plus_one() -> void:
	quota_finished += 1
	#print('CORRECT SHAPE, ADDING TO QUOTA')


func _manual_controls() -> void:
	if Input.is_action_just_pressed("decrease error"):
		for child_node in $".".get_children():
			var child_name = child_node.name
			if child_name.begins_with('ProductionMachine'):
				child_node._decrease_error()
	if Input.is_action_just_pressed("increase error"):
		for child_node in $".".get_children():
			var child_name = child_node.name
			if child_name.begins_with('ProductionMachine'):
				child_node._increase_error()
	if Input.is_action_just_pressed("increase belt speed"):
		production_speed += .25
		print('belt speed is ', production_speed, ' mph')
	if Input.is_action_just_pressed("decrease belt speed"):
		if production_speed > .25: 
			production_speed -= .25
			print('belt speed is ', production_speed, ' mph')

func _show_time() -> void:
	var time_left = stage_time - $StageTime.time_left
	var interpolated_time = start_hour + (time_left / stage_time) * (end_hour - start_hour)
	player_gui.timer_display = format_time(interpolated_time)

func _rotate_lever() -> void:
	var current_prod = production_speed
	$SpeedLever.rotation.z = (($"GUI canvas/Lever Controls".rotate_val - input_min) / (input_max - input_min)*(angle_max_rads - angle_min_rads)+angle_min_rads)
	production_speed = (($"GUI canvas/Lever Controls".rotate_val - input_min) / (input_max - input_min)*(production_max - production_min)+production_min)
	if current_prod != production_speed:
		#var temp_timer = 
		update_timer = true
		
	else:
		update_timer = true

func format_time(passed_time) -> String:
	var hour = int(passed_time)
	var min = int((passed_time - hour)* 60)
	var period = "AM" if hour < 12 else "PM"
	hour = hour if hour <= 12 else hour - 12
	var out_hour = str(hour)
	var out_min = '0'+ str(min) if min <10 else str(min)
	return out_hour + ':' + out_min + period

func _keep_score() -> void:
	player_gui.quota_todo = 'Daily Quota: ' + str(quota)
	player_gui.quota_done = 'Completed: ' + str(quota_finished)
	pass

func _on_stage_time_timeout() -> void:
	if quota_finished!=quota:
		print('game over') 
	else:
		print ("you've won")
	pass # Replace with function body.
