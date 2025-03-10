class_name CrushManager
extends Node

# 0: main menu 1-3: game levels
var level : int = 0

var _level_node : Node = null

var _crush_particle := preload("res://crush_particles.tscn")

var _levels : PackedStringArray = [
	"res://Level1.tscn",
	"res://Level2.tscn",
	"res://Level3.tscn",
	"res://WinScreen.tscn"
]

func set_level(new_level : int) -> void:
	level = new_level

func _ready() -> void:
	if _level_node == null:
		_level_node = get_tree().root.get_child(1)
		
	var music := AudioStreamPlayer2D.new()
	music.stream = load("res://music.wav")
	add_child(music)
	music.play()
	

func next_level() -> void:
	_level_node.queue_free()
	_level_node = load(_levels[level]).instantiate()
	get_tree().root.add_child(_level_node)
	
func play_again() -> void:
	_level_node.queue_free()
	level = 0
	_level_node = load(_levels[level]).instantiate()
	get_tree().root.add_child(_level_node)
	level = 1
	

func determine_combine_result(node1: Crushable, node2: Crushable) -> Node:
	var ret_val: Node = null
	var a: Crushable.CrushableType = node1.type
	var b: Crushable.CrushableType = node2.type
	# make sure a is always less than b for easy lookup
	if a > b:
		var tmp: Crushable.CrushableType = b
		b = a
		a = tmp
	
	if level == 1 or level == 2:
		if a == Crushable.CrushableType.TOMATO and b == Crushable.CrushableType.TOMATO:
			ret_val = load("res://Crushables/Sauce.tscn").instantiate().duplicate()
			ret_val.bigness = (node1.bigness + node2.bigness)/2
		elif a == Crushable.CrushableType.DOUGH and b == Crushable.CrushableType.WATER:
			ret_val = load("res://Crushables/Pasta.tscn").instantiate().duplicate()
			ret_val.bigness = (node1.bigness + node2.bigness)/2
		elif a == Crushable.CrushableType.PASTA and b == Crushable.CrushableType.SAUCE:
			ret_val = load("res://Crushables/Spaghetti.tscn").instantiate().duplicate()
			ret_val.bigness = (node1.bigness + node2.bigness)/2
		elif a == Crushable.CrushableType.SPAGHETTI and b == Crushable.CrushableType.SPAGHETTI:
			ret_val = load("res://Crushables/Spaghetti.tscn").instantiate().duplicate()
			ret_val.mass = node1.mass + node2.mass
			ret_val.bigness = node1.bigness + node2.bigness
	elif level == 3:
		if a == Crushable.CrushableType.RED_PLANET and b == Crushable.CrushableType.RED_PLANET:
			ret_val = load("res://Crushables/Sauce.tscn").instantiate().duplicate()
		if a == Crushable.CrushableType.WATER_PLANET and b == Crushable.CrushableType.WHITE_PLANET:
			ret_val = load("res://Crushables/Pasta.tscn").instantiate().duplicate()
		if a == Crushable.CrushableType.PASTA and b == Crushable.CrushableType.SAUCE:
			ret_val = load("res://Crushables/Spaghetti.tscn").instantiate().duplicate()
		elif a == Crushable.CrushableType.SPAGHETTI and b == Crushable.CrushableType.SPAGHETTI: 
				ret_val = load("res://Crushables/Star.tscn").instantiate().duplicate()
		elif a == Crushable.CrushableType.STAR and b == Crushable.CrushableType.STAR:
				ret_val = load("res://Crushables/Black_Hole.tscn").instantiate().duplicate()
				
	if ret_val != null:
		ret_val.position = (node1.position + node2.position)/2
	
	return ret_val

func crush_event(node1: Crushable, node2: Crushable) -> void:
	if node1 != null and node2 != null:
		var new_node: Node2D = determine_combine_result(node1, node2)
		if new_node != null:
			
			var combine_sound := AudioStreamPlayer2D.new()
			combine_sound.stream = load("res://combine_sound.wav")
			add_child(combine_sound)
			combine_sound.play()
	
			node1.queue_free()
			node2.queue_free()
			if level == 3:
				new_node.drag_s = 0.0
			_level_node.add_child(new_node)
			var new_particle : GPUParticles2D = _crush_particle.instantiate()
			new_particle.position = new_node.position
			new_particle.restart()
			_level_node.add_child(new_particle)
			
			if new_node.type == Crushable.CrushableType.SPAGHETTI:
				_level_node.made_spaghetti()
			
			if level == 1:
				if new_node.type == Crushable.CrushableType.SPAGHETTI and new_node.bigness >= 4:
					next_level()
			elif level == 2:
				if new_node.type == Crushable.CrushableType.SPAGHETTI and new_node.bigness >= 2:
					next_level()
			elif level == 3:
				# TODO: add end game here
				pass
