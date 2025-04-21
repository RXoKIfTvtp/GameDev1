class_name Zombie extends Enemy

@export var field_of_view:float = 150.0;

# Npc movement speed
const SPEED = 100;
# The position the npc should move to or null for idle
var _target = null;

@onready var ray_to_player:RayCast2D = $RayToPlayer;
@onready var audio_stream := $AudioStreamPlayer;

func player_position(pos: Vector2) -> void:
	var direction_to_player = global_position.direction_to(pos);
	var angle = rad_to_deg(direction_to_player.angle()) - self.rotation_degrees;
	var degrees = abs(angle);
	if (degrees >= 180):
		degrees = 360 - degrees;
	
	if (degrees < float(field_of_view) / 2.0):
		ray_to_player.rotation_degrees = angle;
		ray_to_player.force_raycast_update();
		var collision_object = ray_to_player.get_collider();
		if (collision_object != null && collision_object.name.to_lower() == "Player".to_lower()):
			_target = pos;
			pass
	
	# This does exactly the same thing as above except the ray is created per method call
	'''
	# Use a ray cast to determine if the npc can see the player
	# var direction = self.position.direction_to(_target).normalized();
	var space_state = self.get_world_2d().direct_space_state;
	var query = PhysicsRayQueryParameters2D.create(self.global_position, pos);
	# print(self.position, " -> ", pos);
	query.hit_from_inside = false;
	query.collide_with_bodies = true;
	query.collide_with_areas = true;
	query.exclude = [ self ];
	query.collision_mask = 5;
	
	var result = space_state.intersect_ray(query);
	# If the ray hits a Player object/scene set the _target var to the players last known position
	#if result && result.collider.name.to_lower() == "Player".to_lower():
	#	_target = pos;
	if result:
		var collider:Node2D = result.collider;
		if (collider.name == "Area2D"):
			collider = collider.get_parent();
			if (collider != null && collider.is_in_group("player")):
				_target = pos;
				# print("Collided with player!");
	'''
	pass

func _ready() -> void:
	# Add npc to enemy group to recieve player_position updates
	self.add_to_group("enemy");
	self.health = 100;

func _process(_delta: float) -> void:
	if (_target != null):
		# npc is close enough to target to stop moving
		if self.position.distance_to(_target) < 8:
			_target = null;
		else:
			self.look_at(_target);

func _physics_process(delta: float) -> void:
	# Move the npc to a target position if the _target var is not null
	if (_target != null):
		# self.position += self.position.direction_to(_target).normalized() * delta * SPEED;
		self.velocity = self.position.direction_to(_target).normalized() * delta * SPEED * 60;
	else:
		self.velocity = Vector2(0, 0)
	
	#print(self.velocity)

	move_and_slide()
