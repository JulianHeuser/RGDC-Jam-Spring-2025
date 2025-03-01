class_name CrushManager
extends Node


func crush_event(node1: Node, node2: Node) -> void:
	if node1 != null:
		node1.queue_free()
	if node2 != null:
		node2.queue_free()
