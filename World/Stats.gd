extends Control

onready var money_box = $NinePatchRect/GridContainer/Money
onready var happiness_box  = $NinePatchRect/GridContainer/Happiness
onready var population_box = $NinePatchRect/GridContainer/Population

# Called when the node enters the scene tree for the first time.
func _ready():
	set_money(Player.city_funds)
	set_happiness(Player.happiness)
	set_population(Player.population)

func set_money(money):
	money_box.text = "Funds: $" + str(money)

func set_happiness(happiness):
	happiness_box.text = "Happiness: " + str(happiness)

func set_population(population):
	population_box.text = "Population: " + str(population)
