extends Control

var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _input(event):
	if event.is_action_pressed("unlock mouse"):
		
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	visible = is_paused
	if is_paused:
		get_viewport().set_input_as_handled()


func _on_resume_button_pressed():
	
	toggle_pause()

func _on_quit_button_pressed():
	
	get_tree().quit()
