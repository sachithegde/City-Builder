extends Node

var cycle = 48
var day_color = Color(0.933594, 0.933594, 0.933594)
var night_color = Color(0.172549, 0.176471, 0.184314)


var counter = 0
var hour = 0
var day = 1
var month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
var year = 1980

func _ready():
	$Days.start(cycle)
	$DN_Cycle.start(cycle/24)
	get_tree().call_group("time", "_set_time", day, month[counter], year)




func _on_Timer_timeout():
	day += 1
	ET.place_if_changed()
	Player.calc_happiness()
	Player.set_population(ceil(Player.population * 0.1))
	Player.calc_tax()
	if day == 31:
		day = 1
		print(day)
		counter += 1
	if counter == 12:
		counter = 0
		year += 1
	get_tree().call_group("time", "_set_time", day, month[counter], year)


func _on_DN_Cycle_timeout():
	hour += 1
	hour = hour % 24
	
	if hour == 5:
		DnShader.current_color = day_color
		
	if hour == 19:
		DnShader.current_color = night_color
	
