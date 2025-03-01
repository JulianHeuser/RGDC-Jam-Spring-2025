class_name CrushManager
extends Node


func crush_event(node1: Node, node2: Node) -> void:
	node1.queue_free()
	node2.queue_free()
