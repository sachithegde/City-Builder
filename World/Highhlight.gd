extends TileMap

var highlighting = false
var cell_key = -1
var current_cell = Vector2.ZERO
var last_cell = Vector2(10000, 10000)
var allow_color = Color(0, 1, 0, 1)
var disallow_color = Color(1, 0, 0, 1)
var build_neighbours = {Vector2(0, -1): "N", Vector2(1, 0): "E", Vector2(0, 1): "S", Vector2(-1, 0): "W"}

onready var Terrain = get_tree().get_root().find_node("Terrain", true, false)
onready var Elements = get_tree().get_root().find_node("Elements", true, false)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#runs every frame
func _process(_delta):
	if highlighting:
		#Highlights the Cell selected by the player
		var current_pos = world_to_map(get_global_mouse_position())
		current_cell.x = int(current_pos.x) % int(cell_size.x)
		current_cell.y = int(current_pos.y) % int(cell_size.y)
		if current_cell != last_cell:
			set_cellv(last_cell, -1)
			parse_and_remove(last_cell, 10)
			last_cell = current_cell
			set_cellv(current_pos, cell_key)
			if cell_key == 0:
				if is_buildable(current_cell, [0, 16, 17]) or is_buildable(current_cell, [22, 23, 26, 27]):
					modulate = allow_color
				else:
					modulate = disallow_color
			elif cell_key == 2:
				if Terrain.get_cellv(current_cell) == 0 and Elements.get_cellv(current_cell) == -1:
					modulate = allow_color
				else:
					modulate = disallow_color
			elif cell_key == 3 or cell_key == 4:
				if can_build(current_cell):
					modulate = allow_color
					parse_and_place(current_cell, ET.ranges["rescomm"])	
				else:
					modulate = disallow_color
			elif cell_key == 6 or cell_key == 7:
				if can_special_build(current_cell):
					modulate = allow_color
					parse_and_place_special(current_cell, ET.ranges["special"])
				else:
					modulate = disallow_color
			else:
				modulate = Color(1, 1, 1, 1)
func parse_and_place(cell, dist):
	var start_cell = cell + Vector2(-1, -1) * dist
	for i in range(start_cell.x, start_cell.x + (dist * 2) + 1):
		for j in range(start_cell.y, start_cell.y + (dist * 2) + 1):
			var parsing_cell = Vector2(i, j)
			if parsing_cell != cell and can_parse_build(parsing_cell):
				set_cellv(parsing_cell, 5)


func parse_and_place_special(cell, dist):
	var start_cell = cell + Vector2(-1, -1) * dist
	for i in range(start_cell.x, start_cell.x + (dist * 2) + 1):
		for j in range(start_cell.y, start_cell.y + (dist * 2) + 1):
			var parsing_cell = Vector2(i, j)
			if parsing_cell != cell:
				set_cellv(parsing_cell, 5)

func parse_and_remove(cell, dist):
	var start_cell = cell + Vector2(-1, -1) * dist
	for i in range(start_cell.x, start_cell.x + (dist * 2) + 1):
		for j in range(start_cell.y, start_cell.y + (dist * 2) + 1):
			var parsing_cell = Vector2(i, j)
			set_cellv(parsing_cell, -1)

func can_parse_build(pos):
	for n in build_neighbours.keys():
		if Terrain.get_cellv(pos + n) >= 1 and Terrain.get_cellv(pos + n) <= 15:
			if Terrain.get_cellv(pos) == 0 or Terrain.get_cellv(pos) == 16:
				if Elements.get_cellv(pos) == -1:
					return true
	return false

func can_build(pos):
	for n in build_neighbours.keys():
		if Terrain.get_cellv(pos + n) == 5 or Terrain.get_cellv(pos + n) == 10:
			if Terrain.get_cellv(pos) == 0 or Terrain.get_cellv(pos) == 16:
				if Elements.get_cellv(pos) == -1:
					return true
	return false

func can_special_build(pos):
	if Terrain.get_cellv(pos) == 0 or Terrain.get_cellv(pos) == 16:
		if Elements.get_cellv(pos) == -1:
			return true
	return false

func is_buildable(pos, accepted_tiles):
	for ids in accepted_tiles:
		if Terrain.get_cellv(pos) == ids:
			return true
	return false


#Allows Highlighting
func show_temp(cell_key_signal):
	highlighting = true
	cell_key = cell_key_signal

#Disallows Highlighting
func hide_temp():
	clear()
	highlighting = false
	cell_key = -1
