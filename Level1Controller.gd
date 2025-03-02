extends Node2D

func made_spaghetti() -> void:
	_spawn_ingredients()
	
func _move_to_random_pos(node: Node) -> Node:
	node.set_position(Vector2(randf_range(-1152/2, 1152/2), randf_range(-648/2, 648/2)))
	return node

func _spawn_ingredients() -> void:
	add_child(_move_to_random_pos(load("res://Water.tscn").instantiate()))
	add_child(_move_to_random_pos(load("res://Tomato.tscn").instantiate()))
	add_child(_move_to_random_pos(load("res://Tomato.tscn").instantiate()))
	add_child(_move_to_random_pos(load("res://Dough.tscn").instantiate()))
	
func _process(delta: float) -> void:
	pass
	
