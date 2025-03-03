class_name Gun extends Node2D

@export var gun_name := "none";
@export var damage := 0;
@export var fire_type : String;
@export var fire_rate := 0.0; # I will probably 
@export var field_of_fire := 0;
@export var field_of_fire_ads := 0;
@export var pellets := 0;

@export var max_ammo := 0;

# Probably going to need a 
var x := Sprite2D;

var rng := RandomNumberGenerator.new();

# I needed this function because of the way interact_area works
func copy(gun : Gun):
	gun_name = gun.gun_name;
	damage = gun.damage;
	fire_type = gun.fire_type;
	fire_rate = gun.fire_rate;
	field_of_fire = gun.field_of_fire;
	field_of_fire_ads = gun.field_of_fire_ads;
	pellets = gun.pellets;
	

# This function will loop through the ammount of pellets turning them to a random angle calling the interactions (hitting a wall or enemy)
func shoot(aimed, raycast):
	for n in range(0,pellets):
		# Have to create the var before hand or else the compiler throws a hissyfit
		var rand_aim;
		
		if aimed:
			rand_aim = rng.randf_range(-(field_of_fire_ads/2.0), (field_of_fire_ads/2.0));
		else:
			rand_aim = rng.randf_range(-(field_of_fire/2.0), (field_of_fire/2.0));

		print(str(n+1) + ": " + str(rand_aim))
		
		raycast.rotation_degrees += rand_aim;
		
		raycast.force_raycast_update();
			
		# TODO: Add shooting, the surrounding code is just for the bullet cone.
		if raycast.is_colliding():
			print("Pellet " + str(n+1) + " hit.")

		raycast.rotation_degrees -= rand_aim;

func _to_string():
	return gun_name + " " + str(damage) + " " + fire_type + " "
