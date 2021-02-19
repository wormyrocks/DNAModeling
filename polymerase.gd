extends KinematicBody2D

onready var Follow_pol = get_node("Pathfollow")

var speed = 200

func _ready():
	set_process(true)

func _physics_process(delta):
	Follow_pol.set_unit_offset(Follow_pol.get_unit_offset() + speed * delta)
