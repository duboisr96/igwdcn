extends CanvasLayer
class_name GameOverScreen

var current : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	print("game over")
	#current = get_tree().current_scene
	print(current)
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#print(self.Anchor)
	
	
	$ColorRect.modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(1,1,1,1), 2.0)


func game_over(tree):
	print(tree)
	for child in tree.current_scene.get_children():
		if child is CanvasLayer:
			print(child.visible)
			child.add_child(self)

func _on_retry_pressed():
	#get_tree().reload_current_scene()
	get_tree().reload_current_scene()


func _on_exit_pressed():
	get_tree().quit()
