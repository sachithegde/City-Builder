extends CanvasModulate

var current_color = Color(0.172549, 0.176471, 0.184314)

func _ready():
	color = Color(0.172549, 0.176471, 0.184314)


func _process(delta):
	if color != current_color:
		lerp_color(delta)


func lerp_color(delta):
	if color != current_color: 
		color = color.linear_interpolate(current_color, 0.5 * delta)
	
