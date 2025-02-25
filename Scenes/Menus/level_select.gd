extends Control

var duration = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _change_color():
	# Create a random color
	var new_color = Color(randf(), randf(), randf())  # Random RGB values
	
	# Animate the color change with a tween
	create_tween().tween_property($BG, "color", new_color, duration )


func _on_level_1_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1_real.tscn")


func _on_level_2_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_2_real.tscn")

func _on_level_3_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_3_real.tscn")


func _on_exit_button_pressed():
	#or should it go to main menu, oh well
	get_tree().quit()


func _on_timer_timeout():
	_change_color()
	$Timer.start()


func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/tutorial.tscn")
