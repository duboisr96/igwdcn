extends Area3D

@export var shape := 'circle'
@export var color := 'DEEP_SKY_BLUE'
# Called when the node enters the scene tree for the first time.
signal plus_one
signal minus_one


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('grabbable'):
		if body.create_shape == shape && body.create_color == color:
			emit_signal('plus_one')
			body._que_three()
		else:
			emit_signal('minus_one')
			body._que_three()
