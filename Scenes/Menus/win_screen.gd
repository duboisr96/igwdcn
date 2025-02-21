extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$ColorRect.modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(1,1,1,1), 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/title_screen.tscn")
