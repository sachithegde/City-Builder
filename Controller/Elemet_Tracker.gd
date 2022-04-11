extends Node

onready var Terrain: TileMap = get_tree().get_root().find_node("Terrain", true, false)
onready var Elements: TileMap = get_tree().get_root().find_node("Elements", true, false)

var costs = {"road": 5, "bridge": 15, "forest": 25, "resid_office": 200, "comm_office": 500, "power": 900, "police": 900}
var ranges = {"rescomm": 10, "special": 5}


var top = -32
var left = -27
var bottom = 36
var right = 36

var forest = []
var resid_office = []
var comm_office = []
var houses = []
var offices =[]
var power = []
var police = []

func set_forest(cell, cell_id):
	var forest_tile = {cell:cell_id}
	forest.append(forest_tile)
	

func set_resid(cell, cell_id):
	var resid_tile = {cell: cell_id}
	resid_office.append(resid_tile)
	
func set_comm(cell, cell_id):
	var comm_tile = {cell: cell_id}
	comm_office.append(comm_tile)

func set_houses(cell, cell_id):
	var house_tile = {cell: cell_id}
	houses.append(house_tile)

func set_offices(cell, cell_id):
	var office_tile = {cell: cell_id}
	offices.append(office_tile)
	
func set_power(cell, cell_id):
	var power_tile = {cell:cell_id}
	power.append(power_tile)

func set_police(cell, cell_id):
	var police_tile = {cell:cell_id}
	police.append(police_tile)

func remove_forest(cell):
	for index in range(forest.size() - 1):
		if cell == forest[index].keys()[0]:
			forest.remove(index)
			

func remove_resid(cell):
	for index in range(resid_office.size() - 1):
		if cell == resid_office[index].keys()[0]:
			resid_office.remove(index)

func remove_comm(cell):
	for index in range(comm_office.size() - 1):
		if cell == comm_office[index].keys()[0]:
			comm_office.remove(index)


func remove_house(cell):
	for index in range(houses.size() - 1):
		if cell == houses[index].keys()[0]:
			houses.remove(index)
			print("reached")

func remove_offices(cell):
	for index in range(offices.size() - 1):
		if cell == offices[index].keys()[0]:
			offices.remove(index)

func remove_power(cell):
	for index in range(power.size() - 1):
		if cell == power[index].keys()[0]:
			power.remove(index)

func remove_police(cell):
	for index in range(police.size() - 1):
		if cell == police[index].keys()[0]:
			police.remove(index)

func scan_objects():
	for i in range(left, right):
		for j in range(top, bottom):
			var cell = Vector2(i, j)
			var element = Elements.get_cellv(cell)
			#adding sequence
			if element >= 0 and element <= 6 and not in_set(cell, forest):
				set_forest(cell, element)
			if element >= 7 and element <= 10 and not in_set(cell, resid_office):
				set_resid(cell, element)
			if element >= 11 and element <= 18 and not in_set(cell, houses):
				set_houses(cell, element)
			if element >= 19 and element <= 22 and not in_set(cell, comm_office):
				set_comm(cell, element)
			if element >= 23 and element <= 34 and not in_set(cell, offices):
				set_offices(cell, element)
			if element == 35 and not in_set(cell, power):
				set_power(cell, element)
			if element == 36 and not in_set(cell, power):
				set_police(cell, element)
	#removing sequence	
	for index in range(forest.size() - 1):
		if Elements.get_cellv(forest[index].keys()[0]) !=forest[index].keys()[0]:
			forest.remove(index)
	for index in range(resid_office.size() - 1):
		if Elements.get_cellv(resid_office[index].keys()[0]) != resid_office[index].keys()[0]:
			resid_office.remove(index)
	for index in range(houses.size() - 1):
		if Elements.get_cellv(houses[index].keys()[0]) != houses[index].keys()[0]:
			houses.remove(index)
	for index in range(comm_office.size() - 1):
		if Elements.get_cellv(comm_office[index].keys()[0]) != comm_office[index].keys()[0]:
			comm_office.remove(index)
	for index in range(offices.size() - 1):
		if Elements.get_cellv(offices[index].keys()[0]) != offices[index].keys()[0]:
			offices.remove(index)
	for index in range(power.size() - 1):
		if Elements.get_cellv(power[index].keys()[0]) != power[index].keys()[0]:
			power.remove(index)
	for index in range(police.size() - 1):
		if Elements.get_cellv(police[index].keys()[0]) != police[index].keys()[0]:
			police.remove(index)

func stat_parse():
	for index in range(power.size() - 1):
		var auto_buildings = check_parser(power[index].keys()[0], ranges["special"])
		Player.percent_elec = auto_buildings[0] + auto_buildings[1] / houses.size() + offices.size()
	for index in range(police.size() - 1):
		var auto_buildings = check_parser(police[index].keys()[0], ranges["special"])
		Player.percent_safety = auto_buildings[0] + auto_buildings[1] / houses.size() + offices.size()

func money_parse():
	for n in range(offices.size() - 1):
		Player.get_tax(-Player.tax_amount * Player.happiness)

func check_parser(cell, dist):
	var house_tiles = 0
	var office_tiles = 0
	var start_cell = cell + Vector2(-1, -1) * dist
	for i in range(start_cell.x, start_cell.x + (dist * 2) + 1):
		for j in range(start_cell.y, start_cell.y + (dist * 2) + 1):
			var parsing_cell = Vector2(i, j)
			if Elements.get_cellv(parsing_cell) >= 11 and Elements.get_cellv(parsing_cell) <= 18:
				house_tiles += 1
			elif Elements.get_cellv(parsing_cell) >= 11 and Elements.get_cellv(parsing_cell) <= 18:
				office_tiles += 1
	return [house_tiles, office_tiles]
func place_if_changed():
	for n in resid_office:
		Elements.parse_and_place(n.keys()[0], 10, "resid")
	for n in comm_office:
		Elements.parse_and_place(n.keys()[0], 10, "comm")

func in_set(cell, set):
	for i in range(set.size() - 1):
		if cell == set[i].keys()[0]:
			return true
	return false
#

