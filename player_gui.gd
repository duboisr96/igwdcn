extends Control

var timer_display := ''
var quota_todo := ''
var quota_done := ''

@onready var parent = get_tree().get_nodes_in_group('levels')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MarginContainer2/MarginContainer/VBoxContainer/Timer.text = timer_display
	$MarginContainer2/MarginContainer/VBoxContainer/Quota_done.text = quota_done
	$MarginContainer2/MarginContainer/VBoxContainer/Quota_todo.text = quota_todo
	#$MarginContainer2/MarginContainer/VBoxContainer/Test.text = quota_todo
	#$Timer.text = timer_display
	#$Quota_todo.text = quota_todo
	#$Quota_done.text = quota_done
	
