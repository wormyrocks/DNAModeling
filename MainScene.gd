extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	# For debugging
	if event is InputEventMouseButton and event.pressed:
		$Strand/StrandPath.add_point(event.position)
		
	if event is InputEventMouseMotion:
		update()
		
func _draw():
	draw_circle(get_viewport().get_mouse_position(), 5.0, Color.red)
