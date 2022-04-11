extends Node

const HAPP_SAFETY = 30
const HAPP_ELEC = 30
const HAPP_FOREST = 15
const HAPP_HOUSE = 15
const HAPP_OFFICE = 10


var percent_elec = 0
var percent_safety = 0
var percent_forest = 0
var percent_housing = 0
var percent_office = 0


var tax_amt = 5
var city_funds = 5000
var happiness = 20
var population = 10

func _ready():
	pass # Replace with function body.

func set_funds(build_element):
	city_funds += -1 * ET.costs[build_element]
	get_tree().call_group("stats", "set_money", city_funds)

func get_tax(amt):
	city_funds += amt
	get_tree().call_group("stats", "set_money", city_funds)


func set_happiness(amt):
	happiness += amt
	get_tree().call_group("stats", "set_happiness", happiness)

func set_population(nos):
	population += nos
	get_tree().call_group("stats", "set_population", population)
	
func calc_happiness():
	var housing_percent = ET.houses.size()/ population
	var office_percent = ET.offices.size() / population
	if housing_percent > 1:
		percent_housing = 1
	elif housing_percent < 0.4:
		percent_housing = 0
	else:
		percent_housing = 0.5
	if office_percent > 1:
		percent_office = 1
	elif office_percent < 0.4:
		percent_office = 0
	else:
		percent_office = 0.5
	happiness = (percent_elec * HAPP_ELEC) + (percent_forest * HAPP_FOREST) + (percent_safety * HAPP_SAFETY) + (percent_housing * HAPP_HOUSE) + (percent_office * HAPP_OFFICE)
	get_tree().call_group("stats", "set_happiness", happiness)

func calc_tax():
	var tax = happiness * ET.offices.size() * tax_amt
	Player.get_tax(tax)
