extends Node2D

@export var end_point1 : StaticBody2D
@export var end_point2 : StaticBody2D

@export var segment_count : int = 5

@export var move_speed : int = 0

const segment_size = 80

func _ready() -> void:
	end_point2.position = Vector2(0, segment_size * segment_count)
	
	var current_pin := PinJoint2D.new()
	var last_pin : PinJoint2D = null
	end_point1.add_child(current_pin)
	current_pin.node_a = end_point1.get_path()
	
	# Create rope segments
	for i in segment_count:
		var rope : Node2D = load("res://RopeSegment.tscn").instantiate()
		
		current_pin.add_child(rope)
		current_pin.node_b = rope.get_path()
		last_pin = current_pin
		
		current_pin = PinJoint2D.new()
		rope.add_child(current_pin)
		current_pin.node_a = rope.get_path()
		current_pin.position = Vector2(0, segment_size)
		
	current_pin.node_b = end_point2.get_path()

func _physics_process(delta: float) -> void:
	var endpoint1_movement : Vector2 = Vector2(
		Input.get_axis("move_left_1", "move_right_1"),
		Input.get_axis("move_up_1", "move_down_1")
	)
	
	var endpoint2_movement : Vector2 = Vector2(
		Input.get_axis("move_left_2", "move_right_2"),
		Input.get_axis("move_up_2", "move_down_2")
	)
	
	if (endpoint1_movement.length() > 0):
		end_point1.move_and_collide(endpoint1_movement * delta * move_speed)
	
	if (endpoint2_movement.length() > 0):
		end_point2.move_and_collide(endpoint2_movement * delta * move_speed)

	
	
