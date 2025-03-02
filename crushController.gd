class_name Crushable
extends RigidBody2D

enum CrushableType {
	TOMATO,
	DOUGH,
	PASTA,
	WATER,
	SPAGHETTI,
	SAUCE,
	WATER_PLANET,
	WHITE_PLANET,
	RED_PLANET,
	STAR,
	BLACK_HOLE
}

@export var crush_threshold: float = 70
@export var crush_frames: int = 30 # number of frames to be crushed for before triggering a crush event

@export var bigness: float = 1

@export var drag_s : float = 5.0

## what type of crushable object is this?
@export var type: CrushableType = CrushableType.TOMATO

var frames_crushed: float = 0

signal crush_event(node1: Crushable, node2: Crushable)

var crush_obj: Node

var crush_factor: float = 0

func _ready() -> void:
	crush_event.connect(CrushMgr.crush_event)
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	
	# random velocity at spawn
	linear_velocity = Vector2.from_angle(randf()*2.0*PI) * 100.0
	
	linear_damp = drag_s
	angular_damp = drag_s
	
func _process(_delta: float) -> void:
	$Sprite.modulate.r = 1 + 2 * frames_crushed/(float(crush_frames))
	
func _physics_process(_delta: float) -> void:
	scale = Vector2(1, 1) * bigness
	$CollisionShape2D.shape.set_radius(50 * bigness)
	
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
		
		
		
		
