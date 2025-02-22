extends CanvasLayer

var tween
var duration = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	print("title screen")
	#tween.set_trans(Tween.TRANS_LINEAR)
	#tween.set_ease(Tween.EASE_IN)
	#$Timer.start()
	_change_color()

# Function to randomize the color and animate it
func _change_color():
	# Create a random color
	var new_color = Color(randf(), randf(), randf())  # Random RGB values
	
	# Animate the color change with a tween
	create_tween().tween_property($BG, "color", new_color, duration )


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_start_button_pressed():

	get_tree().change_scene_to_file("res://Scenes/Menus/level_select.tscn")


func _on_quit_button_pressed():
	print("quit pls")
	get_tree().quit()


func _on_timer_timeout():
	_change_color()
	$Timer.start()
