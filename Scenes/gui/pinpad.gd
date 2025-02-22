extends Control


@onready var button_positions = [$Circle_Button.position, $Square_Button.position, $Triangle_Button.position, $Red_Button.position, $Blue_Button.position, $Green_Button.position, $End_Button.position, $Start_Button.position]
var am_i_seen_yet = false
var selected_order := []
@onready var monitor_size = $ColorRect2.size
@onready var monitor_offset = $ColorRect2.position

@onready var pass_code_order_sprites = [$TextureRect2, $TextureRect3, $TextureRect4,$TextureRect5, $TextureRect6, $TextureRect7 ]
signal code_entered(code)
@onready var sounds = [ preload("res://Assets/Click 1.wav"), preload("res://Assets/Click 2.wav"), preload("res://Assets/Click 3.wav"), preload("res://Assets/Click 4.wav"), preload("res://Assets/Click 5.wav")]
@export var circle = preload("res://Scenes/objects/shapes/circle.png")
@export var square = preload("res://Scenes/objects/shapes/square.png")
@export var triangle = preload("res://Scenes/objects/shapes/triangle.png")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Circle_Button.texture = circle
	#$Square_Button.texture = square
	#$Triangle_Button.texture = triangle
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	
	_assign_positions()
	if visible:
		var mouse_pos = get_global_mouse_position()
		mouse_pos.x = clamp(mouse_pos.x, monitor_offset.x+10, monitor_size.x+70)
		mouse_pos.y = clamp(mouse_pos.y, monitor_offset.y+10, monitor_size.y+10)
		Input.warp_mouse(mouse_pos)

		if not am_i_seen_yet:
			am_i_seen_yet = true
			_boot_up()
	else:
		$ColorRect.modulate = Color(1, 1, 1)
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
	$Circle_Button.position = button_positions[0]
	$Square_Button.position = button_positions[1]
	$Triangle_Button.position = button_positions[2]
	$Red_Button.position = button_positions[3]
	$Blue_Button.position = button_positions[4]
	$Green_Button.position = button_positions[5]
	$End_Button.position = button_positions[6]
	$Start_Button.position = button_positions[7]

func _boot_up() -> void:
	#print('tweening')
	var tween = create_tween()
	tween.tween_property($ColorRect, 'modulate',Color(1, 1, 1, 0), 2)

#func _on_mouse_entered() -> void:
	#_shuffle_positions()

func _play_random_sound() -> void:
	$AudioStreamPlayer2D.play()


func _on_circle_button_pressed() -> void:
	
	var tween = create_tween()
	$Circle_Button.modulate = Color('INDIGO')
	tween.tween_property($Circle_Button, 'modulate', Color('WHITE'), 0.8)
	
	selected_order.append(('circle'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $Circle_Button.texture_normal
	_play_random_sound()
	
func _on_square_button_pressed() -> void:
	
	var tween = create_tween()
	$Square_Button.modulate = Color('INDIGO')
	tween.tween_property($Square_Button, 'modulate', Color('WHITE'), 0.8)
	
	selected_order.append(('square'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $Square_Button.texture_normal
	_play_random_sound()

func _on_triangle_button_pressed() -> void:
	var tween = create_tween()
	$Triangle_Button.modulate = Color('INDIGO')
	tween.tween_property($Triangle_Button, 'modulate', Color('WHITE'), 0.8)
	selected_order.append(('triangle'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $Triangle_Button.texture_normal
	_play_random_sound()


func _on_red_button_pressed() -> void:
	var tween = create_tween()
	$Red_Button.modulate = Color('INDIGO')
	tween.tween_property($Red_Button, 'modulate', Color('WHITE'), 0.8)
	selected_order.append(('RED'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $Red_Button.texture_normal
	_play_random_sound()


func _on_blue_button_pressed() -> void:
	
	$Blue_Button.modulate = Color('INDIGO')
	var tween = create_tween()
	tween.tween_property($Blue_Button, 'modulate', Color('WHITE'), 0.8)
	selected_order.append(('0484b6'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $Blue_Button.texture_normal
	_play_random_sound()


func _on_green_button_pressed() -> void:
	var tween = create_tween()
	$Green_Button.modulate = Color('INDIGO')
	tween.tween_property($Green_Button, 'modulate', Color('WHITE'), 0.8)
	
	selected_order.append(('GREEN'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $Green_Button.texture_normal
	_play_random_sound()

func _on_end_button_pressed() -> void:
	var tween = create_tween()
	$End_Button.modulate = Color('INDIGO')
	tween.tween_property($End_Button, 'modulate', Color('WHITE'), 0.8)
	
	print('modulating')
	selected_order.append(('End'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $End_Button.texture_normal
	_play_random_sound()


func _on_start_button_pressed() -> void:
	
	var tween = create_tween()
	$Start_Button.modulate = Color('INDIGO')
	tween.tween_property($Start_Button, 'modulate', Color('WHITE'), 0.8)
	
	selected_order.append(('Start'))
	pass_code_order_sprites[selected_order.size() -1 ].texture = $Start_Button.texture_normal
	_play_random_sound()
