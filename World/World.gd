extends Node2D

onready var Cam = $Player_cam
const CAM_OFFSET_Y: int = 300
const CAM_OFFSET_X: int = 800
const CAM_SPEED = 10
const ZOOM_OUT_MAX = Vector2(0.5, 0.5)
const ZOOM_IN_MIN = Vector2(2.5, 2.5)
var zoom = Vector2(1.5, 1.5)


# Called when the node enters the scene tree for the first time.
func _ready():
	ET.Terrain = $YSort/Terrain
	ET.Elements = $YSort/Elements

func _process(delta):
	move_cam()
	zoom_cam(delta)

func move_cam():
	var Positioner = Vector2.ZERO
	if Input.is_action_pressed("camera_up") and Cam.position.y > Cam.limit_top + CAM_OFFSET_Y:
		Positioner.y -= CAM_SPEED;
	elif Input.is_action_pressed("camera_down")and Cam.position.y < Cam.limit_bottom - CAM_OFFSET_Y:
		Positioner.y += CAM_SPEED;
	
	if Input.is_action_pressed("camera_left")and Cam.position.x > Cam.limit_left + CAM_OFFSET_X:
		Positioner.x -= CAM_SPEED;
	elif Input.is_action_pressed("camera_right") and Cam.position.x < Cam.limit_right - CAM_OFFSET_X:
		Positioner.x += CAM_SPEED;
	Cam.position += (Positioner.normalized() * CAM_SPEED)


func zoom_cam(delta):
	if Input.is_action_just_pressed("zoom_in") and zoom < ZOOM_IN_MIN:
		zoom += Vector2(0.25, 0.25)
	elif Input.is_action_just_pressed("zoom_out") and zoom > ZOOM_OUT_MAX:
		zoom -= Vector2(0.25, 0.25)
	if Cam.zoom != zoom and zoom < ZOOM_IN_MIN and zoom > ZOOM_OUT_MAX:
		Cam.zoom = Cam.zoom.linear_interpolate(zoom, 1.5 * delta)
