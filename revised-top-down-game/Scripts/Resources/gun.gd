class_name Gun extends Resource

# TODO: Because of the new version doing upgrades will be hard, although in the save directory I
# could have 3 resources that just changed based on what you have in your inventory.
@export var gun_name : String;
@export_enum(
	"pistol",
	"rifle",
	"buckshot"
) var calibur : String;
@export var damage : int;
@export var pellets : int;
@export var field_of_fire :  int; 
@export var field_of_fire_ads : int;
@export var max_ammo : int;
@export var cur_ammo : int;

@export var icon : Texture2D;

@export var fire_sound : AudioStream;
@export var reload_sound : AudioStream;
@export var dry_fire_sound : AudioStream;

var rng := RandomNumberGenerator.new();

func reload(bullets : int) -> int:
	var required_bullets := (max_ammo - cur_ammo);
	
	if bullets <= 0: #If the player has no bullets (or somehow neagitive bullets)
		return 0;
	elif (bullets - required_bullets) < 0: #If the bullets - the amount needed is neagitive it will reload for the amount remaining
		cur_ammo += bullets;
		return bullets;
	else:
		cur_ammo += required_bullets;
		return required_bullets;

# Returns the point of collision or null
func shoot(aimed : bool, raycast : RayCast2D):
	# var ret = null;
	var shot_results:Array[ShotResult] = [];
	if cur_ammo > 0:
		for n in range(0,pellets):
			# Have to create the var before hand or else the compiler throws a hissyfit
			var rand_aim;
			
			if aimed:
				rand_aim = rng.randf_range(-(field_of_fire_ads/2.0), (field_of_fire_ads/2.0));
			else:
				rand_aim = rng.randf_range(-(field_of_fire/2.0), (field_of_fire/2.0));
			
			raycast.rotation_degrees += rand_aim;
			raycast.force_raycast_update();

			if raycast.is_colliding():
				var collision = raycast.get_collider();
				var _hit_location = raycast.get_collision_point();
				
				if collision is Zombie: #Might change back to enemy later, right now I'm too sleepy to do anything but this as a patch
					collision.take_damage(damage);
					collision._target = raycast.global_position; # causes npc to walk towards player
					shot_results.append(ShotResult.new(_hit_location, true));
				else: # Walls & objects
					shot_results.append(ShotResult.new(_hit_location, false));
				# ret = raycast.get_collision_point();
				
			raycast.rotation_degrees -= rand_aim;
			
		cur_ammo -= 1;
		return shot_results;
	return null;

func _to_string() -> String:
	return gun_name + ": " + calibur + "," + str(damage) + "," + str(pellets) + "," + str(field_of_fire) + "," + str(field_of_fire_ads) + ","  + str(max_ammo) + ","  + str(cur_ammo)
