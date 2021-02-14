extends Path2D

# Distance in pixels between pre-determined points
var bake_interval = 20
var ball_radius = 5


var point_array
var color_array
var color_choices = [Color.red, Color.blue, Color.green, Color.yellow]

# Called when the node enters the scene tree for the first time.
func _ready():
	curve.set_bake_interval(bake_interval)
	point_array = curve.get_baked_points()
	print ("Strand created with %d baked points." % point_array.size())
	color_array = PoolColorArray()
	color_array.resize(point_array.size())
	for i in range (0, point_array.size()):
		color_array.push_back(Color.red)
	pass

func _draw():
	draw_polyline_colors(curve.get_baked_points(), color_array, 1.0, true)
	for i in range (0, point_array.size()):
		var pt = point_array[i]
		draw_circle(Vector2(pt[0], pt[1]), ball_radius, Color(1.0, 0.5, 1.0, 1.0))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
