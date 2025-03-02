extends Node2D

@export var end_point1 : StaticBody2D
@export var end_point2 : StaticBody2D

@export var segment_count : int = 10

@export var move_speed : int = 150

@export var segment_size : int = 20

@export var spring_length : int = 2

var _segment_1 : Node2D
var _segment_2 : Node2D

func _ready() -> void:
	end_point2.position = Vector2(segment_size * segment_count, 0)
	
	var current_pin : Joint2D = DampedSpringJoint2D.new()
	current_pin.length = spring_length
	current_pin.stiffness = 200.0
	current_pin.damping = 0.0
	add_child(current_pin)
	current_pin.node_a = end_point1.get_path()
	
	# Create rope segments
	for i in segment_count:
		var rope : Node2D = load("res://RopeSegment.tscn").instantiate()
		
		
		add_child(rope)
		rope.position = Vector2(segment_size * i, 0)
		
		current_pin.node_b = rope.get_path()
		
		if i == segment_count - 1:
			current_pin = DampedSpringJoint2D.new()
			current_pin.length = spring_length
			current_pin.stiffness = 200.0
			current_pin.damping = 0.0
		else:
			current_pin = PinJoint2D.new()
		rope.add_child(current_pin)
		
		if i == 0: _segment_1 = rope
		elif i == segment_count - 1:
			var n := Node2D.new()
			rope.add_child(n)
			n.position = Vector2(segment_size, 0)
			_segment_2 = n
		
		current_pin.node_a = rope.get_path()
		current_pin.position = Vector2(segment_size, 0)
		
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
	
	const threshold = 20
	if (end_point1.position + endpoint1_movement).distance_to(_segment_1.global_position) > threshold:
		if endpoint1_movement.length() > 0:
			var diff := (end_point1.position - _segment_1.global_position).normalized()
			var rotated := endpoint1_movement.rotated(atan2(diff.y, diff.x))
			rotated.x = min(0, rotated.x)
			endpoint1_movement = rotated.rotated(atan2(diff.y, diff.x))
		else:
			var diff := _segment_1.global_position - end_point1.position
			endpoint1_movement = diff.normalized() * delta * move_speed
	
	if (end_point2.position + endpoint2_movement).distance_to(_segment_2.global_position) > threshold:
		if endpoint2_movement.length() > 0:
			var diff := (end_point2.position - _segment_2.global_position).normalized()
			var rotated := endpoint2_movement.rotated(atan2(diff.y, diff.x))
			rotated.x = min(0, rotated.x)
			endpoint2_movement = rotated.rotated(atan2(diff.y, diff.x))
		else:
			var diff :=  _segment_2.global_position - end_point2.position
			endpoint2_movement = diff.normalized() * delta * move_speed
			
		
	#if (end_point1.position + endpoint1_movement).distance_to(end_point2.position + endpoint2_movement) > segment_size * segment_count:
		#var diff := (end_point1.position - end_point2.position).normalized()
		#var rotated := endpoint1_movement.rotated(-atan2(diff.y, diff.x))
		#rotated.x = min(0, rotated.x)
		#endpoint1_movement = rotated.rotated(atan2(diff.y, diff.x))
		#
		#rotated = endpoint2_movement.rotated(-atan2(-diff.y, -diff.x))
		#rotated.x = min(0, rotated.x)
		#endpoint2_movement = rotated.rotated(atan2(-diff.y, -diff.x))
	
	if (endpoint1_movement.length() > 0):
		end_point1.move_and_collide(endpoint1_movement)
	
	if (endpoint2_movement.length() > 0):
		end_point2.move_and_collide(endpoint2_movement)

	
	
