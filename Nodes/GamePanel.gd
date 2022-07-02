extends Panel

export (NodePath) var game_scene

onready var _mine_slider := $VBoxContainer/Mines/HSlider

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func set_grid_width(value: int):
	GlobalVars.grid_width = value
	set_mine_limit()


func set_grid_height(value: int):
	GlobalVars.grid_height = value
	set_mine_limit()


func set_mine_limit():
	_mine_slider.min_value = max(GlobalVars.grid_width, GlobalVars.grid_height)
	_mine_slider.max_value = (GlobalVars.grid_width * GlobalVars.grid_height) / 2
	if GlobalVars.min_mines < _mine_slider.min_value:
		GlobalVars.min_mines = _mine_slider.min_value
	if GlobalVars.min_mines > _mine_slider.max_value:
		GlobalVars.min_mines = _mine_slider.max_value


func set_mines(value: int):
	set_mine_limit()
	GlobalVars.min_mines = value


func start_button_pressed():
	GlobalVars.first_game = false
	GlobalVars.reset_stage()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
