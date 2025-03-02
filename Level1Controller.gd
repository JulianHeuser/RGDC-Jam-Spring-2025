extends Node2D

func made_spaghetti() -> void:
	_spawn_ingredients()
	
func _move_to_random_pos(node: Node) -> Node:
	node.set_position(Vector2(randf_range(-1152/2, 1152/2), randf_range(-648/2, 648/2)))
	return node

func _spawn_ingredients() -> void:
	add_child(_move_to_random_pos(load("res://Crushables/Water.tscn").instantiate()))
	add_child(_move_to_random_pos(load("res://Crushables/Tomato.tscn").instantiate()))
	add_child(_move_to_random_pos(load("res://Crushables/Tomato.tscn").instantiate()))
	add_child(_move_to_random_pos(load("res://Crushables/Dough.tscn").instantiate()))
	
func _process(delta: float) -> void:
	pass
	
