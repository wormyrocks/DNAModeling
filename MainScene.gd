extends Node2D

export(PackedScene) var ParentStrand
export(PackedScene) var DaughterStrand

# Called when the node enters the scene tree for the first time.
func _ready():
	# Instance Strand scene
	var parent = ParentStrand.instance()
	# Call initialize function (This should really be using a constructor)
	parent.initialize()
	# Add it to the scene
	add_child(parent)
	
	# Initialize daughter strand
	var daughter = DaughterStrand.instance()
	# Call initialize function with parent strand as reference
	daughter.initialize(parent)
	parent.add_child(daughter)

func _input(event):
	# For debugging
	#if event is InputEventMouseButton and event.pressed:
	#	$Strand/StrandPath.add_point(event.position)
		
	if event is InputEventMouseMotion:
		update()
		
func _draw():
	draw_circle(get_viewport().get_mouse_position(), 5.0, Color.red)
