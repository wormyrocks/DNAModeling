extends Path2D

enum Nucleotide {A,C,T,G}
var color_choices = [Color(0.0, 1.0, 0.0, 1.0), Color(0.75,0.20,0.0,1.0), Color(0.75, 0.20, 1.0, 1.0), Color(0.75, 1.0, 0.0, 1.0)]

# Distance in pixels between pre-determined points
var bake_interval = 50

# Length of base pair in pixels
var base_length = 15

var which_side = false

# Array of points
var point_array

# Array of normals (for drawing base pairs tangent to the strand)
var normal_array

# Array of colors (needs to be updated to match array of points)
var color_array

var phys_array

var nearest_index = 0

func initialize():
	normal_array = PoolVector2Array()
	color_array = PoolIntArray()
	curve.set_bake_interval(bake_interval)
	point_array = curve.get_baked_points()
	update_normals()
	print ("Strand created from Bezier curve, converted to %d baked points." % point_array.size())
	color_array.resize(point_array.size())
	# Set random nucleotides (for now)
	for i in range (0, point_array.size()):
		color_array.set(i, randi() % 4)
		var rb = RigidBody2D.new()
		add_child(rb)
	

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
	var target_size = point_array.size()
	var init_size = max(0, normal_array.size() - 1)
	normal_array.resize(target_size)
	for i in range (init_size, target_size):
		var tan_vec = point_array[i] - calc_normal(i) * ( -1 if which_side else 1)
		normal_array.set(i, tan_vec)

func add_point(world_position):
	# Because this adds a geometric point to the 'curve', it can ONLY be called on a parent strand!!
	curve.add_point(world_position - self.position)
	point_array = curve.get_baked_points()
	update_normals()
	print("Adding base pair at position %d,%d. Curve now contains %d points." % [world_position.x, world_position.y, point_array.size()])
	
	# Update color array
	while (color_array.size() < point_array.size()):
		color_array.append(color_choices[randi()%4])
		
	# Calling update() makes sure our _draw function will get called again
	update()
	

func calc_nearest_polymerase_point(curve_offset):
	var new_nearest_index = floor(point_array.size() * curve_offset)
	if (new_nearest_index > nearest_index): 
		nearest_index = new_nearest_index
		print ("Polymerase is closest to point at index %d" % nearest_index)
	
func _process(delta):
	calc_nearest_polymerase_point($Pathfollow.unit_offset)

func _ready():
	pass

func _draw():
	# Draw the backbone
	draw_polyline(normal_array, Color.black, 2.0, true)

	for i in range (0, point_array.size()):
		# Draw tangent lines (between point_array and normal_array)
		draw_line(normal_array[i], point_array[i], color_choices[color_array[i]], 1.5, true)
