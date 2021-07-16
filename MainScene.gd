extends Node2D

export(PackedScene) var StrandObj

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	CreateStrand()

func CreateStrand():
	# Instance Strand scene
	var parent = StrandObj.instance()
	# Call initialize function (This should really be using a constructor)
	parent.initialize(null)
	# Add it to the scene
	add_child(parent)
	
	# Initialize daughter strand
	var daughter = StrandObj.instance()
	# Call initialize function with parent strand as reference
	daughter.initialize(parent)
	add_child(daughter)

func _input(event):
	# For debugging
	#if event is InputEventMouseButton and event.pressed:
	#	$Strand/StrandPath.add_point(event.position)
		
	if event is InputEventMouseMotion:
		update()
		
func _draw():
	draw_circle(get_viewport().get_mouse_position(), 5.0, Color.red)
