extends Area3D

@export var belt_direction := Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	belt_move()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func belt_move() -> void:
	pass
