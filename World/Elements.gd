extends TileMap

onready var Terrain: TileMap = get_tree().get_root().find_node("Terrain", true, false)

var build_neighbours = {Vector2(0, -1): "N", Vector2(1, 0): "E", Vector2(0, 1): "S", Vector2(-1, 0): "W"}



func place_resid():
	if Player.city_funds >= ET.costs["resid_office"]:
		place_building("resid", ET.ranges["rescomm"])
	else:
		get_tree().call_group("hud", "show_error", "Insufficient Funds")
func place_comm():
	if Player.city_funds >= ET.costs["comm_office"]:
		place_building("comm", ET.ranges["rescomm"])
	else:
		get_tree().call_group("hud", "show_error", "Insufficient Funds")

func place_forest():
	if Player.city_funds >= ET.costs["forest"]:
		randomize()
		var pos = get_global_mouse_position()
		var cell = world_to_map(pos)
		var selector = randi() % 7
		if Terrain.get_cellv(cell) == 0:
			set_cellv(cell, selector)
			ET.set_forest(cell, selector)
			Player.set_funds("forest")
		else:
			get_tree().call_group("hud", "show_error", "Cant Grow Forest Here")
	else:
		get_tree().call_group("hud", "show_error", "Insufficient Funds")

func place_power():
	if Player.city_funds >= ET.costs["power"]:
		var pos = get_global_mouse_position()
		var cell = world_to_map(pos)
		if (Terrain.get_cellv(cell) == 0 or Terrain.get_cellv(cell) == 16) and get_cellv(cell) == -1:
			set_cellv(cell, 35)
			ET.set_power(cell, 35)
			Player.set_funds("power")
		else:
			get_tree().call_group("hud", "show_error", "Cant Build Power plant Here")
	else:
		get_tree().call_group("hud", "show_error", "Insufficient Funds")

func place_police():
	if Player.city_funds >= ET.costs["police"]:
		var pos = get_global_mouse_position()
		var cell = world_to_map(pos)
		if (Terrain.get_cellv(cell) == 0 or Terrain.get_cellv(cell) == 16) and get_cellv(cell) == -1:
			set_cellv(cell, 36)
			ET.set_power(cell, 36)
			Player.set_funds("police")
		else:
			get_tree().call_group("hud", "show_error", "Cant Build Police Station Here")
	else:
		get_tree().call_group("hud", "show_error", "Insufficient Funds")

func place_building(build_type, build_range):
	var cell_set = {"resid":{"N": 10, "E": 9, "S": 7, "W": 8}, "comm": {"N" : 22, "E": 21, "S" : 19, "W" : 20}}
	var pos = get_global_mouse_position()
	var cell = world_to_map(pos)
	if can_build(cell):
		Player.set_funds(build_type + "_office")
		var selector = build_dir(cell)
		set_cellv(cell, cell_set[build_type][selector])
		call("set_" + build_type, cell, selector)
		parse_and_place(cell, build_range, build_type)
		
	else:
		get_tree().call_group("hud", "show_error", "Cant Build Here")	


func parse_and_place(cell, dist, build_type):
	var parse_cell_set = {"resid":{"N": [14, 18], "E": [13, 17], "S": [11, 15], "W": [12, 16]},
	 "comm": {"N": [24, 29, 30], "E": [23, 27, 28], "S": [25, 31, 32], "W":[26, 33, 34]}}
	var name_set = {"resid": "houses", "comm": "offices"}
	var start_cell = cell + Vector2(-1, -1) * dist
	for i in range(start_cell.x, start_cell.x + (dist * 2) + 1):
		for j in range(start_cell.y, start_cell.y + (dist * 2) + 1):
			var parsing_cell = Vector2(i, j)
			randomize()
			if parsing_cell != cell and can_parse_build(parsing_cell):
				yield(get_tree().create_timer(0.2), "timeout")
				if can_parse_build(parsing_cell):
					var parse_selector = parse_build_dir(parsing_cell)
					var parse_cell_id_selector = parse_cell_set[build_type][parse_selector][randi() % parse_cell_set[build_type][parse_selector].size()]
					set_cellv(parsing_cell, parse_cell_id_selector)
					call("set_" + name_set[build_type], parsing_cell, parse_cell_id_selector)
	
	
#demolish sequences
func demolish():
	var pos = get_global_mouse_position()
	var cell = world_to_map(pos)
	if has_element(cell):
		if is_forest(cell):
			ET.remove_forest(cell)
			set_cellv(cell, -1)
		if is_resid(cell):
			ET.remove_resid(cell)
			set_cellv(cell, -1)
		if is_house(cell):
			ET.remove_house(cell)
			set_cellv(cell, -1)
		if is_comm(cell):
			ET.remove_comm(cell)
			set_cellv(cell, -1)
		if is_office(cell):
			ET.remove_offices(cell)
			set_cellv(cell, -1)
		if is_power(cell):
			ET.remove_power(cell)
			set_cellv(cell, -1)
		if is_police(cell):
			ET.remove_police(cell)
			set_cellv(cell, -1)
#check functions
func has_element(pos):
	if get_cellv(pos) != -1:
		return true
	else:
		return false
	
func is_forest(pos):
	var list = [0, 1, 2, 3, 4, 5, 6]
	for n in list:
		if get_cellv(pos) == n:
			return true
	return false
	
func is_resid(pos):
	if get_cellv(pos) >= 7 and get_cellv(pos) <= 10:
		return true
	return false

func is_house(pos):
	if get_cellv(pos) >= 11 and get_cellv(pos) <= 18:
		return true
	return false

func is_comm(pos):
	if get_cellv(pos) >= 19 and get_cellv(pos) <= 22:
		return true
	return false

func is_office(pos):
	if get_cellv(pos) >= 23 and get_cellv(pos) <= 34:
		return true
	return false

func is_power(pos):
	if get_cellv(pos) == 35:
		return true
	return false

func is_police(pos):
	if get_cellv(pos) == 36:
		return true
	return false
	
func can_build(pos):
	for n in build_neighbours.keys():
		if Terrain.get_cellv(pos + n) == 5 or Terrain.get_cellv(pos + n) == 10:
			if Terrain.get_cellv(pos) == 0 or Terrain.get_cellv(pos) == 16:
				if get_cellv(pos) == -1:
					return true
	return false

func can_parse_build(pos):
	for n in build_neighbours.keys():
		if Terrain.get_cellv(pos + n) >= 1 and Terrain.get_cellv(pos + n) <= 15:
			if Terrain.get_cellv(pos) == 0 or Terrain.get_cellv(pos) == 16:
				if get_cellv(pos) == -1:
					return true
	return false

func build_dir(pos):
	for n in build_neighbours.keys():
		if Terrain.get_cellv(pos + n) == 5 or Terrain.get_cellv(pos + n) == 10:
			return build_neighbours[n]

func parse_build_dir(pos):
	for n in build_neighbours.keys():
		if Terrain.get_cellv(pos + n) >= 1 and Terrain.get_cellv(pos + n) <= 15:
			return build_neighbours[n]


func set_resid(cell, cell_id):
	ET.set_resid(cell, cell_id)


func set_comm(cell, cell_id):
	ET.set_comm(cell, cell_id)


func set_houses(cell, cell_id):
	ET.set_houses(cell, cell_id)

func set_offices(cell, cell_id):
	ET.set_offices(cell, cell_id)
