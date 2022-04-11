extends TextureRect

onready var Time_Text = $Time

func _set_time(day, month, year):
	Time_Text.text = str(day) + " " + month + " " + str(year)
