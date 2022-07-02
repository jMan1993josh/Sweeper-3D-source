extends Area

func _on_Boundary_body_entered(body):
	if body.name == 'Player':
		body.reset_pos()
