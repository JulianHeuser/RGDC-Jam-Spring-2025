extends RigidBody2D

@export var crush_threshold: float = 500
@export var crush_frames: int = 30 # number of frames to be crushed for before triggering a crush event

var frames_crushed: float = 0

signal crush_event(node1: Node, node2: Node)

var crush_obj: Node

func _init() -> void:
	pass
	
func _ready() -> void:
	linear_velocity = Vector2(900, 100)
	crush_event.connect(CrushMgr.crush_event)

	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta):
	pass

# On the rigid body:
func _integrate_forces(state : PhysicsDirectBodyState2D):
	var crush_factor: float = 0;
	for contact_index in state.get_contact_count():
		var object_hit := state.get_contact_collider_object(contact_index)
		if (is_instance_valid(object_hit)): # To fix a case where an object hits the player as player is deleted during level transition (intermission)
			var imp := state.get_contact_impulse(contact_index)
			var collide_obj := state.get_contact_collider_object(contact_index)
			if !collide_obj.to_string().contains("Rope"):
				crush_obj = collide_obj
			
			crush_factor += imp.length()
			
	if crush_factor > crush_threshold:
		if frames_crushed < crush_frames:
			frames_crushed += 1
	else:
		if frames_crushed > 1:
			frames_crushed -= 0.1
		
		
	if frames_crushed > crush_frames:
		crush_event.emit(self, crush_obj)
