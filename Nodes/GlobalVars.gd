extends Node


var grid_width = 9
var grid_height = 9
var min_mines = 9
var flags = 0
var buttons = 0
var mouse_sensitivity = 20.0
var first_game = true
var stage : Node


func reset_stage():
	if stage:
		var p = stage.get_parent()
		p.remove_child(stage)
		p.add_child(stage)
