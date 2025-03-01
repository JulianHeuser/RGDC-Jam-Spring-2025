extends RigidBody2D

@export var crush_threshold: float = 500
@export var crush_frames: int = 30 # number of frames to be crushed for before triggering a crush event

var previous_velocity = Vector3 (0,0,0)

var frames_crushed: float = 0


func _init() -> void:
	pass
	
func _ready() -> void:
	linear_velocity = Vector2(900, 100)

	
func _process(delta: float) -> void:
	pass
	#linear_velocity -= linear_velocity.normalized() * friction
	
	
func _physics_process(delta):
	pass
	#var delta_velocity = self.linear_velocity - previous_velocity
	#var acceleration = delta_velocity / delta
	#

# On the rigid body:
func _integrate_forces(state : PhysicsDirectBodyState2D):
	var imp_sum: Vector2 = Vector2(0, 0)
	var crush_factor: float = 0;
	for contact_index in state.get_contact_count():
		var object_hit := state.get_contact_collider_object(contact_index)
		if (is_instance_valid(object_hit)): # To fix a case where an object hits the player as player is deleted during level transition (intermission)
			var imp := state.get_contact_impulse(contact_index)
			
			imp_sum += imp
			crush_factor += imp.length()
	if crush_factor > crush_threshold:
		if frames_crushed < crush_frames:
			frames_crushed += 1
	else:
		if frames_crushed > 1:
			frames_crushed -= 0.1
		
		
	if frames_crushed > crush_frames:
		print("crush event", crush_factor)

# And in my physics Autoload:
#static func handle_rigid_body_collision(object : PhysicsProp, object_hit : Node3D, position : Vector3, velocity : Vector3, impulse : Vector3):
	## TODO: Sometimes impulse is 0, 0, 0, even though there is a solid impact.  Jolt bug?
	#if (impulse.length_squared() > MIN_IMPULSE_RESPONSE_SQUARED):
		#Combat.handle_rigid_body_hit(object, object_hit, velocity, impulse)
		#var speed_change := impulse.length() / object.mass
		#SoundSystem.play_physics_impact_sound(object, position, speed_change)
