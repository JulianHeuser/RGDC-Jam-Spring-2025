class_name CrushManager
extends Node

var _crush_particle := preload("res://crush_particles.tscn")

#var combine_dict: Dictionary = {
	#0: load("res://Pasta.tscn"),
#}

func determine_combine_result(node1: Crushable, node2: Crushable) -> Node:
	var ret_val: Node = null
	var a: Crushable.CrushableType = node1.type
	var b: Crushable.CrushableType = node2.type
	# make sure a is always less than b for easy lookup
	if a > b:
		var tmp: int = b
		b = a
		a = tmp
		
	if a == Crushable.CrushableType.TOMATO and b == Crushable.CrushableType.TOMATO:
		ret_val = load("res://Crushables/Sauce.tscn").instantiate()
	elif a == Crushable.CrushableType.DOUGH and b == Crushable.CrushableType.WATER:
		ret_val = load("res://Crushables/Pasta.tscn").instantiate()
	elif a == Crushable.CrushableType.PASTA and b == Crushable.CrushableType.SAUCE:
		ret_val = load("res://Crushables/Spaghetti.tscn").instantiate()
	elif a == Crushable.CrushableType.SPAGHETTI and b == Crushable.CrushableType.SPAGHETTI:
		ret_val = load("res://Crushables/Spaghetti.tscn").instantiate()
		ret_val.mass = node1.mass + node2.mass
		ret_val.bigness = node1.bigness + node2.bigness
		
	if ret_val != null:
		ret_val.position = (node1.position + node2.position)/2
	
	return ret_val

func crush_event(node1: Crushable, node2: Crushable) -> void:
	if node1 != null and node2 != null:
		var new_node: Node2D = determine_combine_result(node1, node2)
		if new_node != null:
			node1.queue_free()
			node2.queue_free()
			get_tree().root.get_node("Level1").add_child(new_node)
			var new_particle : GPUParticles2D = _crush_particle.instantiate()
			new_particle.position = new_node.position
			new_particle.restart()
			get_tree().root.get_node("Level1").add_child(new_particle)
			
			if new_node.type == Crushable.CrushableType.SPAGHETTI:
				get_tree().root.get_node("Level1").made_spaghetti()
