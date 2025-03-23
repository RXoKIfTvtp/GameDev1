class_name Gun extends Node

@export var gun_sprite : Texture2D;
@export var gun_name : String;
@export var firetype : String;
@export var calibur : String;
@export var damage : int;
@export var fof : int;
@export var fof_ads : int;
@export var pellets : int;
@export var ammo_capacity : int;
@onready var cur_ammo := ammo_capacity;

@export var gunshot_sound : AudioEffect;
@export var reload_sound : AudioEffect;
@export var dry_fire_sound : AudioEffect;


var rng := RandomNumberGenerator.new();

func copy(gun : Gun):
	gun_name = gun.gun_name;
	firetype = gun.firetype;
	calibur = gun.calibur;
	damage = gun.damage;
	fof = gun.fof;
	fof_ads = gun.fof_ads;
	pellets = gun.pellets;
	ammo_capacity = gun.ammo_capacity;
	cur_ammo = gun.cur_ammo;


func reload() -> void:
	# For testing
	cur_ammo = ammo_capacity;
	print("Reloaded");
	
	# Idea: If pellets > 1 load 1 at a time? Add a reload type? Bullet & mag would allow for variability.
	


func shoot(aimed : bool, raycast : RayCast2D) -> void:
	if cur_ammo > 0:
		# TODO: Play gun shooting sound
		for n in range(0,pellets):
			# Have to create the var before hand or else the compiler throws a hissyfit
			var rand_aim;
			
			if aimed:
				rand_aim = rng.randf_range(-(fof_ads/2.0), (fof_ads/2.0));
			else:
				rand_aim = rng.randf_range(-(fof/2.0), (fof/2.0));

			#print(str(n+1) + ": " + str(rand_aim))
			
			raycast.rotation_degrees += rand_aim;
			raycast.force_raycast_update();

			if raycast.is_colliding():
				var collision = raycast.get_collider();
				var _hit_location = raycast.get_collision_point();
				if collision is Enemy:
					collision.take_damage(damage);
				else:
					print("");

			raycast.rotation_degrees -= rand_aim;
			
			cur_ammo -= 1;
	else:
		# TODO: Play dry fire noise
		pass
		
func _to_string():
	return gun_name + " " + str(damage) + " ";
