extends TileMap

const DIR_KEYS = {
	Vector2(0, -1): 1,
	Vector2(0, 1): 4,
	Vector2(1, 0): 2,
	Vector2(-1, 0): 8 
}

func place_road():
	if Player.city_funds >= ET.costs["road"]:
		var pos = get_global_mouse_position()
		var cell = world_to_map(pos)
		if is_buildable(cell, [0, 16, 17]):
			var cell_id = check_neighbors(cell)
			get_tree().call_group("elements", "demolish")
			Player.set_funds("road")
			set_cellv(cell,cell_id)
			set_neighbors(cell)
		elif is_buildable(cell, [22, 23, 26, 27]):
			if Player.city_funds >= ET.costs["bridge"]:
				place_bridge()
			else:
				get_tree().call_group("hud", "show_error", "Insufficient Funds")
		else:
			get_tree().call_group("hud", "show_error", "Cant Build Road Here")
	else:
		get_tree().call_group("hud", "show_error", "Insufficient Funds")
	

func place_bridge():
	if Player.city_funds >= ET.costs["bridge"]:
		var list = {22: 25, 23: 24, 26: 32, 27: 33}
		var pos = get_global_mouse_position()
		var cell = world_to_map(pos)
		if is_buildable(cell, [22, 23, 26, 27]):
			for id in list.keys():
				if get_cellv(cell) == id:
					Player.set_funds("bridge")
					set_cellv(cell, list[id])
					set_neighbors(cell)
					return
		else:
			get_tree().call_group("hud", "show_error", "Cant Build Bridge Here")
	else:
		get_tree().call_group("hud", "show_error", "Insufficient Funds")
		
	

func check_neighbors(pos):
	var cell_to_place = 0
	for n in DIR_KEYS.keys():
		if is_road(pos + n):
			cell_to_place += DIR_KEYS[n]
		elif is_bridge(pos + n):
			cell_to_place += DIR_KEYS[n]
	if cell_to_place == 0:
		cell_to_place = 15
	return cell_to_place
	
func set_neighbors(pos):
	var cell_checking
	for n in DIR_KEYS.keys():
		cell_checking = pos + n
		if is_road(cell_checking):
			var cell_id = check_neighbors(cell_checking)
			set_cellv(cell_checking, cell_id)

func demolish():
	var pos = get_global_mouse_position()
	var cell = world_to_map(pos)
	if is_road(cell) or get_cellv(cell) == 0:
		set_cellv(cell, 16)
		set_neighbors(cell)
	if is_bridge(cell):
		var list = {25: 22, 24: 23, 32: 26, 33: 27}
		for id in list.keys():
			if get_cellv(cell) == id:
				set_cellv(cell, list[id])
				set_neighbors(cell)
		
func is_buildable(pos, accepted_tiles):
	for ids in accepted_tiles:
		if get_cellv(pos) == ids:
			return true
	return false

func is_bridge(pos):
	var list = [24, 25, 32, 33]
	for ids in list:
		if get_cellv(pos) == ids:
			return true 
	return false
	
func is_road(pos):
	if get_cellv(pos) >= 1 and get_cellv(pos) <= 15:
		return true
	else:
		return false
