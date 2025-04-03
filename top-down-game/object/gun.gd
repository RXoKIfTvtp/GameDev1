class_name Gun extends Node

@export var gun_name : String;
@export var firetype : String;
@export var calibur : String;
@export var damage : int;
@export var fof : int;
@export var fof_ads : int;
@export var pellets : int;
@export var ammo_capacity : int;
@onready var cur_ammo := ammo_capacity;

@export var gun_sprite := "";

@export var fire_sound : AudioStream;
@export var reload_sound : AudioStream;
@export var dry_fire_sound : AudioStream;

@onready var obj := $Sprite2D;

var rng := RandomNumberGenerator.new();

func _ready() -> void:
	obj.texture = load(gun_sprite);

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
	
	fire_sound = gun.fire_sound;
	reload_sound = gun.reload_sound;
	dry_fire_sound = gun.dry_fire_sound;

func reload() -> void:
	# For testing
	cur_ammo = ammo_capacity;
	print("Reloaded weapon.")
	
	# Idea: If pellets > 1 load 1 at a time? Add a reload type? Bullet & mag would allow for variability.
	

# Returns the point of collision or null
func shoot(aimed : bool, raycast : RayCast2D):
	# var ret = null;
	var shot_results = [];
	if cur_ammo > 0:
		# var sound = AudioStreamPlayer.new();
		# sound.stream = load("res://asset/audio/pistol-shot-233473.mp3");
		# sound.play(0.15);
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
					collision._target = raycast.global_position; # causes npc to walk towards player
					shot_results.append(ShotResult.new(_hit_location, true));
					pass
				else: # Walls & objects
					print("Round didn't hit anything interesting.");
					shot_results.append(ShotResult.new(_hit_location, false));
					pass
				# ret = raycast.get_collision_point();
				
			raycast.rotation_degrees -= rand_aim;
			
		cur_ammo -= 1;
	else:
		pass; # Player is out of ammo
	return shot_results;
		
func _to_string():
	return gun_name + " " + str(damage) + " ";
