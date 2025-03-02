class_name Crushable
extends RigidBody2D

#enum CrushableType:
	#TOMATO
	#DOUGH
	#PASTA
	#WATER
	#SPAGHETTI

@export var crush_threshold: float = 70
@export var crush_frames: int = 30 # number of frames to be crushed for before triggering a crush event

# what type of crushable object is this?
# 0: tomato
# 1: dough
# 2: pasta
# 3: water
# 4: spaghetti!
@export var type: int = -1

var frames_crushed: float = 0

signal crush_event(node1: Crushable, node2: Crushable)

var crush_obj: Node

var crush_factor: float = 0

func _ready() -> void:
	crush_event.connect(CrushMgr.crush_event)
	
func _process(delta: float) -> void:
	$Sprite.modulate.r = 1 + 2 * frames_crushed/(float(crush_frames))
	
func _physics_process(delta: float) -> void:
	pass
	
# don't remove. I'm doing important work!
func crushable() -> void:
	pass

# On the rigid body:
func _integrate_forces(state : PhysicsDirectBodyState2D) -> void:
	crush_factor = 0
	for contact_index: int in state.get_contact_count():
		var object_hit := state.get_contact_collider_object(contact_index)
		if (is_instance_valid(object_hit)): # To fix a case where an object hits the player as player is deleted during level transition (intermission)
			var imp := state.get_contact_impulse(contact_index)
			var collide_obj := state.get_contact_collider_object(contact_index)
			
			crush_factor += imp.length()
			if collide_obj.has_method("crushable"):
				crush_obj = collide_obj
			
	if crush_factor > crush_threshold:
		if frames_crushed < crush_frames:
			frames_crushed += 1
	else:
		if frames_crushed > 0:
			frames_crushed -= 0.5
		
	#if type == 1:
		#print(crush_factor)
		
	if frames_crushed > crush_frames:
		(func() -> void: crush_event.emit(self, crush_obj)).call_deferred()
		
		
		
		
