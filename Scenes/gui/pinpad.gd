extends Control


@onready var button_positions = [$TextureRect/Circle_Button.position, $TextureRect/Square_Button.position, $TextureRect/Triangle_Button.position, $TextureRect/Red_Button.position, $TextureRect/Blue_Button.position, $TextureRect/Green_Button.position, $TextureRect/End_Button.position, $TextureRect/Start_Button.position]
var am_i_seen_yet = false
var selected_order := []
@onready var monitor_size = $TextureRect/ColorRect2.size
@onready var monitor_offset = $TextureRect/ColorRect2.position
@onready var pass_code_order_sprites = [$TextureRect/TextureRect2, $TextureRect/TextureRect3, $TextureRect/TextureRect4,$TextureRect/TextureRect5, $TextureRect/TextureRect6, $TextureRect/TextureRect7 ]
signal code_entered(code)
@onready var sounds = [ preload("res://Assets/Click 1.wav"), preload("res://Assets/Click 2.wav"), preload("res://Assets/Click 3.wav"), preload("res://Assets/Click 4.wav"), preload("res://Assets/Click 5.wav")]
@export var circle = preload("res://Scenes/objects/shapes/circle.png")
@export var square = preload("res://Scenes/objects/shapes/square.png")
@export var triangle = preload("res://Scenes/objects/shapes/triangle.png")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$TextureRect/Circle_Button.texture = circle
	#$TextureRect/Square_Button.texture = square
	#$TextureRect/Triangle_Button.texture = triangle
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(monitor_offset)
	monitor_offset = $TextureRect/ColorRect2.global_position
	monitor_size = $TextureRect/ColorRect2.size + monitor_offset
	_assign_positions()
	if visible and not Engine.get_time_scale() == 0:
		var mouse_pos = get_global_mouse_position()
		
		mouse_pos.x = clamp(mouse_pos.x, monitor_offset.x+5, monitor_size.x - 101/2)
		mouse_pos.y = clamp(mouse_pos.y, monitor_offset.y+5, monitor_size.y-130/2)
		Input.warp_mouse(mouse_pos)

		if not am_i_seen_yet:
			am_i_seen_yet = true
			_boot_up()
	else:
		$TextureRect/ColorRect.modulate = Color(1, 1, 1)
		#print('unesesenn')
		_shuffle_positions()
		am_i_seen_yet = false
	
	$Sprite2D.position = get_local_mouse_position()
	
	if selected_order.size() >= 6:
		code_entered.emit(selected_order)
		selected_order.clear()


#func _on_focus_entered() -> void:
	#_shuffle_positions()

func _shuffle_positions() -> void:
	selected_order.clear()
	button_positions.shuffle()
	for sprite in pass_code_order_sprites:
		sprite.texture = null

func _assign_positions() -> void:
	$TextureRect/Circle_Button.position = button_positions[0]
	$TextureRect/Square_Button.position = button_positions[1]
	$TextureRect/Triangle_Button.position = button_positions[2]
	$TextureRect/Red_Button.position = button_positions[3]
	$TextureRect/Blue_Button.position = button_positions[4]
	$TextureRect/Green_Button.position = button_positions[5]
	$TextureRect/End_Button.position = button_positions[6]
	$TextureRect/Start_Button.position = button_positions[7]

func _boot_up() -> void:
	#print('tweening')
	var tween = create_tween()
	tween.tween_property($TextureRect/ColorRect, 'modulate',Color(1, 1, 1, 0), 2)

#func _on_mouse_entered() -> void:
	#_shuffle_positions()

func _play_random_sound() -> void:
	$AudioStreamPlayer2D.play()


func _on_circle_button_pressed() -> void:
	
	var tween = create_tween()
	$TextureRect/Circle_Button.modulate = Color('INDIGO')
	tween.tween_property($TextureRect/Circle_Button, 'modulate', Color('WHITE'), 0.8)
	
	selected_order.append(('circle'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $TextureRect/Circle_Button.texture_normal
	_play_random_sound()
	
func _on_square_button_pressed() -> void:
	
	var tween = create_tween()
	$TextureRect/Square_Button.modulate = Color('INDIGO')
	tween.tween_property($TextureRect/Square_Button, 'modulate', Color('WHITE'), 0.8)
	
	selected_order.append(('square'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $TextureRect/Square_Button.texture_normal
	_play_random_sound()

func _on_triangle_button_pressed() -> void:
	var tween = create_tween()
	$TextureRect/Triangle_Button.modulate = Color('INDIGO')
	tween.tween_property($TextureRect/Triangle_Button, 'modulate', Color('WHITE'), 0.8)
	selected_order.append(('triangle'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $TextureRect/Triangle_Button.texture_normal
	_play_random_sound()


func _on_red_button_pressed() -> void:
	var tween = create_tween()
	$TextureRect/Red_Button.modulate = Color('INDIGO')
	tween.tween_property($TextureRect/Red_Button, 'modulate', Color('WHITE'), 0.8)
	selected_order.append(('RED'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $TextureRect/Red_Button.texture_normal
	_play_random_sound()


func _on_blue_button_pressed() -> void:
	
	$TextureRect/Blue_Button.modulate = Color('INDIGO')
	var tween = create_tween()
	tween.tween_property($TextureRect/Blue_Button, 'modulate', Color('WHITE'), 0.8)
	selected_order.append(('0484b6'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $TextureRect/Blue_Button.texture_normal
	_play_random_sound()


func _on_green_button_pressed() -> void:
	var tween = create_tween()
	$TextureRect/Green_Button.modulate = Color('INDIGO')
	tween.tween_property($TextureRect/Green_Button, 'modulate', Color('WHITE'), 0.8)
	
	selected_order.append(('GREEN'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $TextureRect/Green_Button.texture_normal
	_play_random_sound()

func _on_end_button_pressed() -> void:
	var tween = create_tween()
	$TextureRect/End_Button.modulate = Color('INDIGO')
	tween.tween_property($TextureRect/End_Button, 'modulate', Color('WHITE'), 0.8)
	
	print('modulating')
	selected_order.append(('End'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $TextureRect/End_Button.texture_normal
	_play_random_sound()


func _on_start_button_pressed() -> void:
	
	var tween = create_tween()
	$TextureRect/Start_Button.modulate = Color('INDIGO')
	tween.tween_property($TextureRect/Start_Button, 'modulate', Color('WHITE'), 0.8)
	
	selected_order.append(('Start'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $TextureRect/Start_Button.texture_normal
	_play_random_sound()
