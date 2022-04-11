extends Node

var ambo = preload("res://World/Ambo.tscn")
onready var Terrain = get_tree().get_root().find_node("Terrain", true, false)


func _process(delta):
	if Input.is_action_just_pressed("click"):
		var pos = Terrain.world_to_map(Terrain.get_global_mouse_position())
		var new_ambo = ambo.instance()
		new_ambo.position = Terrain.map_to_world(pos)  + Vector2(0, 20)
		add_child(new_ambo)
		new_ambo = ambo.instance()
		new_ambo.position = Terrain.map_to_world(pos)  + Vector2(15, 30)
		add_child(new_ambo)
		
