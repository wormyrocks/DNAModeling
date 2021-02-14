extends Path2D

# Distance in pixels between pre-determined points
var bake_interval = 20

var ball_radius = 5

# Array of points
var point_array

# Array of colors (needs to be updated to match array of points)
var color_array = PoolColorArray()

# Color palette
var color_choices = [Color(0.0, 1.0, 0.0, 1.0), Color(0.75,0.20,0.0,1.0), Color(0.75, 0.20, 1.0, 1.0), Color(0.75, 1.0, 0.0, 1.0)]

# Called when the node enters the scene tree for the first time.
func _ready():
	curve.set_bake_interval(bake_interval)
	point_array = curve.get_baked_points()
	print ("Strand created with %d baked points." % point_array.size())
	color_array.resize(point_array.size())
	var num_colors = color_choices.size()
	for i in range (0, point_array.size()):
		color_array.set(i, color_choices[randi() % num_colors])
	pass

func _draw():
	draw_polyline_colors(curve.get_baked_points(), color_array, 2.0, true)
	for i in range (0, point_array.size()):
		var pt = point_array[i]
		draw_circle(Vector2(pt[0], pt[1]), ball_radius, color_array[i])
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
