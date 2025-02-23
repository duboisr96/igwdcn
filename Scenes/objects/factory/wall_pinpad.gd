extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CSGBox3D.hide()
	$CollisionShape3D.hide()
	$PopUp.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_3d_body_entered(body):
	print('body entered')
	print(body)
	$PopUp.show()



func _on_area_3d_body_exited(body):
	print('body left')
	$PopUp.hide()
