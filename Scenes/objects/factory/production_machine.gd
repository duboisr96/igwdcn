extends StaticBody3D


@export var shape_scene: PackedScene

@export var created_shape := 'circle'
@export var created_color := 'red'
@export var created_velocity := Vector3(.5,0,0)


#var make_shape
#var make_color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	print('creating shape from machine')
	var new_shape = shape_scene.instantiate()
	new_shape.create_shape = 'circle' #shape of product to be produced
	new_shape.create_color = 'red' #color of shape to be produced
	new_shape.create_velocity = created_velocity #DIRECTION OF PROD LINE
	add_child(new_shape)
	pass # Replace with function body.
