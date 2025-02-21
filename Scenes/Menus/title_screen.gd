extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	print("title screen")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	print("start pls")
	get_tree().change_scene_to_file("res://Scenes/Menus/level_select.tscn")


func _on_quit_button_pressed():
	print("quit pls")
	get_tree().quit()
