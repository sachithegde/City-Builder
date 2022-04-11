extends Control

var on_menu = false

var player_build = false
var road_build = false
var bridge_build = false
var forest_build = false
var resid_build = false
var comm_build = false
var power_build = false
var police_build = false
var destroy = false

var build_menu = false
const BUILD_MENU_IN = Vector2(0,0)
const BUILD_MENU_OUT = Vector2(-225, 0)
var ui_speed = 0.5


onready var Error_message: Popup = get_tree().get_root().find_node("Error", true, false)
onready var Error_label: Label = get_tree().get_root().find_node("ErrorLabel", true, false)
onready var Error_timer: Timer = get_tree().get_root().find_node("PopTimer", true, false)


#Checks inputs
func _input(event):
	if event.is_action_pressed("Escape_build"):
		road_build = false
		bridge_build = false
		forest_build = false
		resid_build = false
		comm_build = false
		power_build = false
		police_build = false
		destroy = false
		
		
		build_menu = false
		_move_out()
		get_tree().call_group("highlight", "hide_temp")
		#Set of events if Player Clicks the Left Mouse Button 
	if not on_menu:
		if event.is_action_pressed("click"):
			if road_build:
				get_tree().call_group("terrain", "place_road")
			if bridge_build:
				get_tree().call_group("terrain", "place_bridge")
			if forest_build:
				get_tree().call_group("elements", "place_forest")
			if resid_build:
				get_tree().call_group("elements", "place_resid")
			if comm_build:
				get_tree().call_group("elements", "place_comm")
			if power_build:
				get_tree().call_group("elements", "place_power")
			if police_build:
				get_tree().call_group("elements", "place_police")
			if destroy:
				get_tree().call_group("demolish", "demolish")
	#Move Build Menu
	if event.is_action_pressed("build_toggle"):
		if not build_menu:
			build_menu = true
			_move_in()
		else:
			build_menu = false
			_move_out()
#Demolish Button Pressed
func _on_Demolish_pressed():
	road_build = false
	bridge_build = false
	forest_build = false
	resid_build = false
	comm_build = false
	power_build = false
	police_build = false
	if not destroy:
		destroy = true
		get_tree().call_group("highlight", "show_temp", 1)
	else:
		destroy = false

#Road Button Pressed
func _on_Place_road_pressed():
	bridge_build = false
	forest_build = false
	resid_build = false
	comm_build = false
	power_build = false
	police_build = false
	destroy = false
	if not road_build:
		road_build = true
		get_tree().call_group("highlight", "show_temp", 0)
	else:
		road_build = false

#bridge Button Pressed
func _on_Place_bridge_pressed():
	road_build = false
	forest_build = false
	resid_build = false
	comm_build = false
	power_build = false
	police_build = false
	destroy = false
	if not bridge_build:
		bridge_build = true
		get_tree().call_group("highlight", "show_temp", 0)
	else:
		bridge_build = false
#Forest Button Pressed
func _on_Place_forest_pressed():
	road_build = false
	bridge_build = false
	resid_build = false
	comm_build = false
	power_build = false
	police_build = false
	destroy = false
	if not forest_build:
		forest_build = true
		get_tree().call_group("highlight", "show_temp", 2)
	else:
		forest_build = false

#Resid Office Button pressed
func _on_Place_resid_office_pressed():
	road_build = false
	bridge_build = false
	forest_build = false
	comm_build = false
	power_build = false
	police_build = false
	destroy = false
	if not resid_build:
		resid_build = true
		get_tree().call_group("highlight", "show_temp", 3)
	else:
		resid_build = false
#Comm office Button Placed
func _on_Place_comm_office_pressed():
	road_build = false
	bridge_build = false
	forest_build = false
	resid_build = false
	power_build = false
	police_build = false
	destroy = false
	if not comm_build:
		comm_build = true
		get_tree().call_group("highlight", "show_temp", 4)
	else:
		comm_build = false

func _on_Place_Power_pressed():
	road_build = false
	bridge_build = false
	forest_build = false
	resid_build = false
	comm_build = false
	police_build = false
	destroy = false
	if not power_build:
		power_build = true
		get_tree().call_group("highlight", "show_temp", 6)
	else:
		power_build = false

func _on_Place_Police_pressed():
	road_build = false
	bridge_build = false
	forest_build = false
	resid_build = false
	comm_build = false
	power_build = false
	destroy = false
	if not police_build:
		police_build = true
		get_tree().call_group("highlight", "show_temp", 7)
	else:
		police_build = false
	
#animate Build Menu
func _move_in():
	$Tween.interpolate_property(self, "rect_position", rect_position, BUILD_MENU_IN, ui_speed, Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
func _move_out():
	$Tween.interpolate_property(self, "rect_position", rect_position, BUILD_MENU_OUT, ui_speed, Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	road_build = false
	bridge_build = false
	forest_build = false
	destroy = false
	get_tree().call_group("highlight", "hide_temp")


#popup Stuff
func show_error(message):
	Error_label.text = message
	Error_message.popup()
	Error_timer.start()



func _on_PopTimer_timeout():
	Error_timer.stop()
	Error_message.visible = false


func _on_BuildMenu_mouse_entered():
	on_menu = true
	


func _on_BuildMenu_mouse_exited():
	on_menu = false
	







