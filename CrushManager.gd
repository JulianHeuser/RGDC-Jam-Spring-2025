class_name CrushManager
extends Node

#var combine_dict: Dictionary = {
	#0: load("res://Pasta.tscn"),
#}

func determine_combine_result(node1: Crushable, node2: Crushable) -> Node:
	var pasta_tmp: Node = null
	if node1.type == 0 && node2.type == 0:
		pasta_tmp = load("res://Pasta.tscn").instantiate()
	
	return pasta_tmp

func crush_event(node1: Crushable, node2: Crushable) -> void:
	if node1 != null and node2 != null:
		var new_node: Node = determine_combine_result(node1, node2)
		if new_node != null:
			node1.queue_free()
			node2.queue_free()
			get_tree().root.get_node("Level1").add_child(new_node)
