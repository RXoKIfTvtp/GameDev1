extends CharacterBody2D

# Npc movement speed
const SPEED = 200;
# The position the npc should move to or null for idle
var _target = null;

func player_position(pos: Vector2) -> void:
	# Use a ray cast to determine if the npc can see the player
	# var direction = self.position.direction_to(_target).normalized();
	var space_state = self.get_world_2d().direct_space_state;
	var query = PhysicsRayQueryParameters2D.create(self.position, pos);
	query.hit_from_inside = false;
	query.collide_with_bodies = true;
	query.collide_with_areas = true;
	query.exclude = [ self ];
	var result = space_state.intersect_ray(query);
	# If the ray hits a Player object/scene set the _target var to the players last known position
	if result && result.collider.name.to_lower() == "Player".to_lower():
		_target = pos;
	pass

func _ready() -> void:
	# Add npc to enemy group to recieve player_position updates
	self.add_to_group("enemy");

func _process(_delta: float) -> void:
	if (_target != null):
		# npc is close enough to target to stop moving
		if self.position.distance_to(_target) < 8:
			_target = null;
		else:
			self.look_at(_target);
		pass
	pass

func _physics_process(delta: float) -> void:
	# Move the npc to a target position if the _target var is not null
	if (_target != null):
		# self.position += self.position.direction_to(_target).normalized() * delta * SPEED;
		self.velocity = self.position.direction_to(_target).normalized() * delta * SPEED * 60;
	else:
		self.velocity = Vector2(0, 0)
		pass
	move_and_slide()
