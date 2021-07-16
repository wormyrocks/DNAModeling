extends Node2D


enum Nucleotide {A,C,T,G}
var color_choices = [Color(0.0, 1.0, 0.0, 1.0), Color(0.75,0.20,0.0,1.0), Color(0.75, 0.20, 1.0, 1.0), Color(0.75, 1.0, 0.0, 1.0)]

var parent_strand

var base_length = 15

var which_side

# Array of points
var point_array
# Array of normals (for drawing base pairs tangent to the strand)
var normal_array
# Array of colors (needs to be updated to match array of points)
var color_array

var start_index = 0
var end_index = 0

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

func update_normals():
	var target_size = point_array.size()
	var init_size = max(0, normal_array.size() - 1)
	normal_array.resize(target_size)
	for i in range (init_size, target_size):
		var tan_vec = point_array[i] - calc_normal(i) * ( -1 if which_side else 1)
		normal_array.set(i, tan_vec)

func initialize(parent_strand_):
	normal_array = PoolVector2Array()
	parent_strand=parent_strand_
	which_side = not parent_strand_.which_side
	print ("This is a daughter strand! Parent strand has %d points" % parent_strand.point_array.size())
	color_array = parent_strand.color_array
	for i in range (0, color_array.size()):
		color_array[i] = (color_array[i] + 2) % 4
	point_array = parent_strand.point_array
	update_normals()

func _process(delta):

	if (parent_strand.nearest_index > end_index):
		end_index = parent_strand.nearest_index
		update()

func _draw():	
	# Draw the backbone
	# This is an awful way to do it, fix later
	print("%d" % end_index)
	var a = Array(normal_array).slice(start_index, end_index)
	draw_polyline(PoolVector2Array(a), Color.black, 2.0, true)

	for i in range (start_index, end_index+1):
		# Draw tangent lines (between point_array and normal_array)
		draw_line(normal_array[i], point_array[i], color_choices[color_array[i]], 1.5, true)

