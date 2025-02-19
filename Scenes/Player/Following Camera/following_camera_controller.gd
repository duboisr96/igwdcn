extends Node3D

@export var sensitivity := 0.005
@export var invert_horizontal := true
@export var invert_vertical := true

#limit
@export var min_limit_x: float
@export var max_limit_x: float

var can_adjust = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func rotate_from_vector(v: Vector2):
	if (v.length() == 0) : return
	if (invert_horizontal) :
		v.x *= -1
	if (invert_vertical) :
		v.y *= -1
	rotation.y += v.x
	rotation.x += v.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)

	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && can_adjust:
		#rotating around y axis using horizontal mouse movenet
		rotate_from_vector(event.relative * sensitivity)
