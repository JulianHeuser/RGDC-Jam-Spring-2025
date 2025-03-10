class_name Factory
extends StaticBody2D

@export var spawnable: PackedScene
@export var max_spawnable_allowed: int = 10
@export var spawn_bigness: float = 1.0

var amt_in_scene: int = 0

var spawnable_inst: Node


func notify(node1_rm: Node, node2_rm: Node, node_added: Node) -> void:
	if node1_rm.type == spawnable_inst.type:
		amt_in_scene -= 1
	if node2_rm.type == spawnable_inst.type:
		amt_in_scene -= 1
	
	if node_added.type == spawnable_inst.type:
		amt_in_scene += 1

func _timer_timeout() -> void:
	if amt_in_scene < max_spawnable_allowed:
		# spawn a new spawnable in the parent
		var spawned: Node = spawnable_inst.duplicate()
		spawned.bigness = spawn_bigness
		spawned.position = position
		get_parent().add_child(spawned)
		amt_in_scene += 1

func _ready() -> void:
	spawnable_inst = spawnable.instantiate()
	$Timer.timeout.connect(_timer_timeout)
	amt_in_scene = 0
