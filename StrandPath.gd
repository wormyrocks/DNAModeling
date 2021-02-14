extends Path2D

# Distance in pixels between pre-determined points
var bake_interval = 20

# Length of base pair in pixels
var base_length = 10

# Array of points
var point_array

# Array of normals (for drawing base pairs tangent to the strand)
var normal_array = PoolVector2Array()

# Array of colors (needs to be updated to match array of points)
var color_array = PoolColorArray()

# Color palette
var color_choices = [Color(0.0, 1.0, 0.0, 1.0), Color(0.75,0.20,0.0,1.0), Color(0.75, 0.20, 1.0, 1.0), Color(0.75, 1.0, 0.0, 1.0)]

# Recalculate normal vectors to each point in the scene; probably should be called every time the curve is edited
func calc_normals():
	var tan_vec
	for i in range (0, point_array.size()):
		# Populate array of points tangent to strand with length 10
		if (i != point_array.size()-1): tan_vec = (point_array[i+1]-point_array[i]).tangent().normalized()*base_length
		normal_array.append(Vector2(point_array[i][0] + tan_vec[0], point_array[i][1] + tan_vec[1]))

# Called when the node enters the scene tree for the first time.
func _ready():
	curve.set_bake_interval(bake_interval)
	point_array = curve.get_baked_points()
	print ("Strand created with %d baked points." % point_array.size())
	color_array.resize(point_array.size())
	var num_colors = color_choices.size()
	for i in range (0, point_array.size()):
		color_array.set(i, color_choices[randi() % num_colors])
	calc_normals()

func _draw():
	draw_polyline_colors(curve.get_baked_points(), color_array, 2.0, true)
	for i in range (0, point_array.size()):
		# Don't draw balls
		#draw_circle(point_array[i], 5, color_array[i])
		
		# Draw tangent lines
		draw_line(point_array[i], normal_array[i], color_array[i], 1.5, true)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
