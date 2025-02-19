extends Control


@onready var vslider = $VSlider
var rotate_val = 0
var can_warp = true
var am_holding = false
var previous_mouse_position = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_val = vslider.value
	#tp_mouse()
	var current_mouse_position = get_global_mouse_position()
	var mouse_movement = current_mouse_position.y - previous_mouse_position.y
	#print(vslider.value)
	if visible:
		if mouse_movement >0:
			vslider.value += 5
			#print('up!')
		elif mouse_movement < 0:
			#print('down!')
			vslider.value -= 5
		vslider.value = clamp(vslider.value, vslider.min_value, vslider.max_value)
		previous_mouse_position = current_mouse_position

	#if Input.is_action_pressed('interact') && visible:
		#update_slider_value()
		#am_holding = true
	#else:
		#am_holding = false
	
	
	$ProgressBar.value = $VSlider.value
	if $VSlider.value <20:
		$VSlider.value = 20
	if $ProgressBar.value <20:
		$ProgressBar.value = 20
	pass

#func tp_mouse():
	#if can_warp && am_holding:
		#print('warping')
		#var slider_value = $VSlider.value
		#var slider_position = remap(slider_value, vslider.min_value, vslider.max_value, 0, vslider.size.y)
		#var global_position = vslider.global_position
		#var warp_position = global_position + Vector2(0, slider_position)
		#Input.warp_mouse(Vector2.ZERO)
		#can_warp = false
func update_slider_value() -> void:
	#var local_mouse_pos = vslider.get_local_mouse_position().y
	
	
	
	#var new_value = remap(local_mouse_pos, 0, vslider.size.y, vslider.max_value, vslider.min_value)
	#vslider.value = clamp(new_value, vslider.min_value, vslider.max_value)
	pass
func _on_mouse_exited() -> void:
	can_warp = true


func _on_mouse_entered() -> void:
	print('entered')
	previous_mouse_position = get_global_mouse_position()
	pass # Replace with function body.
