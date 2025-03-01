extends Node2D

@export var end_point1 : Node2D
@export var end_point2 : Node2D

@export var segment_count : int = 5

const segment_size = 80

func _ready() -> void:
	var rope_prefabs : Array[Node2D] = []
	end_point2.position = Vector2(0, segment_size * segment_count)
	
	# Create rope segments
	for i in segment_count:
		var rope_a : Node2D = load("res://RopeSegment.tscn").instantiate();
		add_child(rope_a)
		rope_a.position = Vector2(0, segment_size * i)
		rope_prefabs.append(rope_a)
	
	# Create rope pins
	var pin : PinJoint2D = PinJoint2D.new()
	pin.set_node_a(end_point1.get_path())
	pin.set_node_b(rope_prefabs[0].get_path())
	add_child(pin)
	pin.position = Vector2(0, segment_size)
	
	for i in rope_prefabs.size():
		pin = PinJoint2D.new()
		if i == rope_prefabs.size() - 1:
			pin.set_node_a(rope_prefabs[i].get_path())
			pin.set_node_b(end_point2.get_path())
		else:
			pin.set_node_a(rope_prefabs[i].get_path())
			pin.set_node_b(rope_prefabs[i + 1].get_path())
		add_child(pin)
		pin.position = Vector2(0, segment_size * (i + 1))

#func _process(delta: float) -> void:
	#var endpoint1_movement : Vector2 = Input.get_axis()
