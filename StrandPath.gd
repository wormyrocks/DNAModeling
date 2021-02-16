extends Path2D

enum Nucleotide {A,C,T,G}
var color_choices = [Color(0.0, 1.0, 0.0, 1.0), Color(0.75,0.20,0.0,1.0), Color(0.75, 0.20, 1.0, 1.0), Color(0.75, 1.0, 0.0, 1.0)]

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

# Recalculate normal vectors to each point in the scene; probably should be called every time the curve is edited
func calc_normals():
	var target_size = point_array.size()
	normal_array.resize(target_size)
	var tan_vec
	for i in range (0, target_size):
		# Populate array of points tangent to strand
		if (i != target_size-1): tan_vec = point_array[i] - (point_array[i+1]-point_array[i]).tangent().normalized()*base_length
		normal_array.set(i, tan_vec)

func add_point(position):
	curve.add_point(position)
	point_array = curve.get_baked_points()
	
	print("Adding base pair at position %d,%d. Curve now contains %d points." % [position.x, position.y, point_array.size()])
	
	# Recalculate normals (inefficient; really only necessary for newly added points)
	calc_normals()
	
	# Update color array
	while (color_array.size() < point_array.size()):
		color_array.append(color_choices[randi()%4])
		
	# Calling update() makes sure our _draw function will get called again
	update()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	curve.set_bake_interval(bake_interval)
	point_array = curve.get_baked_points()
	print ("Strand created with %d baked points." % point_array.size())
	color_array.resize(point_array.size())
	for i in range (0, point_array.size()):
		color_array.set(i, color_choices[randi() % 4])
	calc_normals()
	
	
func _draw():
	draw_polyline_colors(normal_array, color_array, 2.0, true)
	for i in range (0, point_array.size()):
		# Don't draw balls
		#draw_circle(point_array[i], 10, color_array[i])
		
		# Draw tangent lines
		draw_line(normal_array[i], point_array[i], color_array[i], 1.5, true)
		if (i == point_array.size()-1):
			print ("drawing last point at %d %d" % [point_array[i].x, point_array[i].y])
			#draw_circle(point_array[i], 10, color_array[i])
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
