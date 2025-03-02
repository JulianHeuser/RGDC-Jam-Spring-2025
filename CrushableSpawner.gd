extends StaticBody2D

@export var spawnable: Crushable
@export var max_spawnable_allowed: int = 10


func _timer_timeout() -> void:
	pass
	# spawn a new spawnable in the parent
	
	#get_parent().add_child()

func _ready() -> void:
	$Timer.timeout.connect(_timer_timeout)
