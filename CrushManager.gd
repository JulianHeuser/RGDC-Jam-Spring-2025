class_name CrushManager
extends Node

#var combine_dict: Dictionary = {
	#0: load("res://Pasta.tscn"),
#}

func determine_combine_result(node1: Crushable, node2: Crushable) -> Node:
	var ret_val: Node = null
	var a: int = node1.type
	var b: int = node2.type
	if a > b:
		var tmp: int = b
		b = a
		a = tmp
	if a == 0 and b == 0:
		ret_val = load("res://dough.tscn").instantiate()
	elif a == 1 and b == 3:
		ret_val = load("res://Pasta.tscn").instantiate()
		
	if ret_val != null:
		ret_val.position = (node1.position + node2.position)/2
	
	return ret_val

func crush_event(node1: Crushable, node2: Crushable) -> void:
	if node1 != null and node2 != null:
		var new_node: Node = determine_combine_result(node1, node2)
		if new_node != null:
			node1.queue_free()
			node2.queue_free()
			get_tree().root.get_node("Level1").add_child(new_node)
