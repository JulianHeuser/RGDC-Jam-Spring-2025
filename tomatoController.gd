extends RigidBody2D

@export var friction: int = 0.4

func _init() -> void:
	pass
	
func _ready() -> void:
	linear_velocity = Vector2(100, 100)

	
func _process(delta: float) -> void:
	linear_velocity -= linear_velocity.normalized() * friction
	
