extends Path2D

enum Nucleotide {A,C,T,G}
var color_choices = [Color(0.0, 1.0, 0.0, 1.0), Color(0.75,0.20,0.0,1.0), Color(0.75, 0.20, 1.0, 1.0), Color(0.75, 1.0, 0.0, 1.0)]

var parent_strand
# Determines which side of the central path we render on
var is_daughter = true

# Disable/enable hacky way of drawing alternate side of strand
#var draw_other_side = false

# Distance in pixels between pre-determined points
var bake_interval = 20

# Length of base pair in pixels
var base_length = 15

# Array of points
var point_array

# Array of normals (for drawing base pairs tangent to the strand)
var normal_array = PoolVector2Array()

# Array of colors (needs to be updated to match array of points)
var color_array = PoolColorArray()

func initialize(parent_strand_):
	parent_strand = parent_strand_
	if (parent_strand == null):
		is_daughter = false
	if is_daughter:
		print ("This is a daughter strand! Parent strand has %d points" % parent_strand.point_array.size())
		curve = parent_strand.get_partial_curve(0)
		

func get_partial_curve(offset):
	return curve

func calc_normal(point_index):
	var pt0
	var pt1
	if (point_index == 0):
		pt0 = point_array[point_index]
		pt1 = point_array[point_index+1]
	elif (point_index == point_array.size()-1):
		pt0 = point_array[point_index-1]
		pt1 = point_array[point_index]
	else:
		pt0 = point_array[point_index-1]
		pt1 = point_array[point_index+1]
	return ((pt1-pt0).tangent().normalized())*base_length

# Recalculate normal vectors to each point in the strand; probably should be called every time the curve is edited
func update_normals():
	point_array = curve.get_baked_points()
	var target_size = point_array.size()
	var init_size = max(0, normal_array.size() - 1)
	normal_array.resize(target_size)
	for i in range (init_size, target_size):
		var tan_vec = point_array[i] - calc_normal(i) * ( -1 if is_daughter else 1)
		normal_array.set(i, tan_vec)

func add_point(world_position):
	curve.add_point(world_position - self.position)
	update_normals()
	print("Adding base pair at position %d,%d. Curve now contains %d points." % [world_position.x, world_position.y, point_array.size()])
	
	# Update color array
	while (color_array.size() < point_array.size()):
		color_array.append(color_choices[randi()%4])
		
	# Calling update() makes sure our _draw function will get called again
	update()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	curve.set_bake_interval(bake_interval)
	update_normals()
	print ("Strand created with %d baked points." % point_array.size())
	color_array.resize(point_array.size())
	for i in range (0, point_array.size()):
		color_array.set(i, color_choices[randi() % 4])

func _draw():
	
	# Draw the backbone
	draw_polyline_colors(normal_array, color_array, 2.0, true)
	
	var other_side_array;
	var other_side_col_array;
#
#	if (draw_other_side):
#		other_side_array = PoolVector2Array()
#		other_side_col_array = PoolColorArray()
	
	for i in range (0, point_array.size()):
		# Draw tangent lines (between point_array and normal_array)
		draw_line(normal_array[i], point_array[i], color_array[i], 1.5, true)
		
#		if (draw_other_side):
#			# Calculate point at opposite side of strand
#			other_side_array.append(point_array[i]*2-normal_array[i])
#			other_side_col_array.append(color_array[(i+2)%4])
#			draw_line(other_side_array[i], point_array[i], other_side_col_array[i], 1.5, true)
#
#	if (draw_other_side):
#		draw_polyline_colors(other_side_array, other_side_col_array, 2.0, true)
