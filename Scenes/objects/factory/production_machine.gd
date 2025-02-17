extends StaticBody3D


@export var shape_scene: PackedScene

@export var shape_to_create := 'triangle'
@export var color_to_create := 'GREEN'
@export var creating_velocity := Vector3(.5,0,0)


#var make_shape
#var make_color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	print('creating ', color_to_create, ' ', shape_to_create,' from machine')
	var new_shape = shape_scene.instantiate()
	new_shape.create_shape = shape_to_create #shape of product to be produced
	new_shape.create_color = color_to_create #color of shape to be produced
	new_shape.create_velocity = creating_velocity #DIRECTION OF PROD LINE
	add_child(new_shape)
	shape_to_create = 'square'
	color_to_create = 'DEEP_SKY_BLUE'
	pass # Replace with function body.
