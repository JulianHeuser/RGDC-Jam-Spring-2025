extends Node2D

@export var end_point1 : StaticBody2D
@export var end_point2 : StaticBody2D

@export var segment_count : int = 10

@export var move_speed : int = 50

@export var segment_size : int = 20

func _ready() -> void:
	end_point2.position = Vector2(0, segment_size * segment_count)
	#$DampedSpringJoint2D.length = segment_size * segment_count
	
	var current_pin := PinJoint2D.new()
	add_child(current_pin)
	current_pin.node_a = end_point1.get_path()
	
	# Create rope segments
	for i in segment_count:
		var rope : Node2D = load("res://RopeSegment.tscn").instantiate()
		
		current_pin.add_child(rope)
		current_pin.node_b = rope.get_path()
		
		current_pin = PinJoint2D.new()
		rope.add_child(current_pin)
		current_pin.node_a = rope.get_path()
		current_pin.position = Vector2(0, segment_size)
		
	current_pin.node_b = end_point2.get_path()

func _physics_process(delta: float) -> void:
	var endpoint1_movement : Vector2 = Vector2(
		Input.get_axis("move_left_1", "move_right_1"),
		Input.get_axis("move_up_1", "move_down_1")
	) * delta * move_speed
	
	var endpoint2_movement : Vector2 = Vector2(
		Input.get_axis("move_left_2", "move_right_2"),
		Input.get_axis("move_up_2", "move_down_2")
	) * delta * move_speed
	
	if (end_point1.position + endpoint1_movement).distance_to(end_point2.position + endpoint2_movement) > segment_size * segment_count:
		var diff := (end_point1.position - end_point2.position).normalized()
		var rotated := endpoint1_movement.rotated(-atan2(diff.y, diff.x))
		rotated.x = 0
		endpoint1_movement = rotated.rotated(atan2(diff.y, diff.x))
		
		rotated = endpoint2_movement.rotated(-atan2(-diff.y, -diff.x))
		rotated.x = 0
		endpoint2_movement = rotated.rotated(atan2(-diff.y, -diff.x))
	
	if (endpoint1_movement.length() > 0):
		end_point1.move_and_collide(endpoint1_movement)
	
	if (endpoint2_movement.length() > 0):
		end_point2.move_and_collide(endpoint2_movement)

	
	
