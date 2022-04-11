extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func show_message(heading, message):
	$NinePatchRect/Heading.text = heading
	$NinePatchRect/Message.text = message
	popup()


func _on_TextureButton_pressed():
	$NinePatchRect/Heading.text = ""
	$NinePatchRect/Message.text = ""
	self.visible = false
