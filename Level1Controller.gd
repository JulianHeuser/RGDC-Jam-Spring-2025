extends Node2D

@export var spawn_to_replenish : Array[PackedScene]

@export var level : int = 1

func _ready() -> void:
	CrushMgr.set_level(level)

func made_spaghetti() -> void:
	_spawn_ingredients()
	
func _move_to_random_pos(node: Node) -> Node:
	node.set_position(Vector2(randf_range(int(-get_viewport_rect().size.x/2), int(get_viewport_rect().size.x/2)), randf_range(-get_viewport_rect().size.y/2, get_viewport_rect().size.y/2)))
	return node

func _spawn_ingredients() -> void:
	for r : PackedScene in spawn_to_replenish:
		add_child(_move_to_random_pos(r.instantiate()))
