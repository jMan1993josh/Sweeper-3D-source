#tool
extends GridMap


export(int) var map_w = 9
export(int) var map_h = 9
export(int) var min_mines = 9
export(bool) var redraw  setget redraw

var _button = preload("res://Nodes/Button/Button.tscn")
var _player_obj = preload("res://Nodes/Player/Player.tscn")
var _rng = RandomNumberGenerator.new()
var _cur_player

enum Tiles { EMPTY, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, MINE }


func _enter_tree():
	map_w = GlobalVars.grid_width
	map_h = GlobalVars.grid_height
	min_mines = GlobalVars.min_mines
	GlobalVars.buttons = 0
	GlobalVars.flags = 0
	generate()
	set_buttons()
	add_player()


func redraw(value = null):
	# only do this if we are working in the editor
	if !Engine.is_editor_hint(): return
	generate()


func generate():
	_rng.randomize()
	translation = Vector3.ZERO
	delete_children(self)
	clear()
	create_grid()
	add_mines()
	set_cell_numbers()
	#set_buttons()


func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


func create_grid():
	for x in range(0, map_w):
		for z in range(0, map_h):
			set_cell_item(x, 0, z, Tiles.EMPTY)


func add_mines():
	var count = 0
	var mines = min_mines
	while mines >= 0:
		count = 0
		var random_chance = _rng.randi() % get_used_cells().size()+1
		for x in range(0, map_w):
			for z in range(0, map_h):
				if get_cell_item(x, 0, z) != Tiles.MINE:
					count += 1
					if count == random_chance:
						mines -= 1
						set_cell_item(x, 0, z, Tiles.MINE)
						break
#		if count == random_chance:
#			break


func set_cell_numbers():
	for x in range(0, map_w):
		for z in range(0, map_h):
			if get_cell_item(x, 0, z) != Tiles.MINE:
				set_cell_item(x, 0, z, check_nearby(x, z))


func set_buttons():
	for x in range(0, map_w):
		for z in range(0, map_h):
			var item = get_cell_item(x, 0, z)
			var p = _button.instance()
			add_child(p)
			p.global_transform.origin = map_to_world(x, 0, z)
			p.set_up(item == Tiles.EMPTY, item == Tiles.MINE)
			if (item == Tiles.MINE):
				GlobalVars.flags += 1
			else:
				GlobalVars.buttons += 1
				


func add_player():
	var p = _player_obj.instance()
	add_child(p)
	p.translation = Vector3(map_w, 2, map_h)
	_cur_player = p
	p._cur_pos = p.translation


func check_nearby(x, z):
	var count = 0
	if get_cell_item(x, 0, z-1) == Tiles.MINE:  count += 1
	if get_cell_item(x, 0, z+1) == Tiles.MINE:  count += 1
	if get_cell_item(x-1, 0, z) == Tiles.MINE:  count += 1
	if get_cell_item(x+1, 0, z) == Tiles.MINE:  count += 1
	
	if get_cell_item(x+1, 0, z+1) == Tiles.MINE:  count += 1
	if get_cell_item(x-1, 0, z+1) == Tiles.MINE:  count += 1
	if get_cell_item(x-1, 0, z-1) == Tiles.MINE:  count += 1
	if get_cell_item(x+1, 0, z-1) == Tiles.MINE:  count += 1
	return count
