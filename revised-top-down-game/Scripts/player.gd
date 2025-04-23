class_name Player extends CharacterBody2D

const SPEED := 300;
const MAX_HEALTH := 100.0;
const MAX_BATTERY := 60000.0;
var cur_health := MAX_HEALTH;
var cur_battery := 0.0;
var is_controllable : bool = true;
var damaging := 0; # How many NPCs are damaging the player

# Filled just for visulization
var inv := {	
	"bullet" : {
		"buckshot":0,
		"pistol":0,
		"rifle":0
	},
	"consumable": {
		"battery" : 0,
		"medkit" : 0
	},
	"crafting" : {
		"duct_tape" : 0,
		"metal_pipe" : 0,
		"scrap" : 0,
		"screw" : 0
	},
	"key" : []
}

var weapons := [];

var interactions := [];

var in_range := [];

# --- Onready variables ---
@onready var player_sprite := $Look/Sprite2D;

@onready var look := $Look;
@onready var flashlight := $Look/Lights/Flashlight;
@onready var knife := $Look/Knife;
@onready var gun := $Look/Gun;
@onready var interact_label := $InteractionLabel;
@onready var timer := $Timer;

# Used for gun shot sound effects
@onready var audio_stream_player := $AudioStreamPlayer;
# Used for player recieving damage sound effect
@onready var audio_stream_player2 := $AudioStreamPlayer2;

# --- Canvas Layers ---
@onready var upgrade_ui := $UpgradeUI;
@onready var inventory_ui := $InventoryUI;
@onready var pause_menu := $PauseMenu;

@onready var gun_flash := $Look/GunFlash;
@onready var strike_sparks := $Look/StrikeSparks
@onready var strike_bloods := $Look/StrikeBloods

var _h_strike_spark = preload("res://Objects/Gun Effects/strike_spark.tscn");
var _h_strike_blood = preload("res://Objects/Gun Effects/strike_blood.tscn");

var _damage_stx = preload("res://Assets/Audio/male_grunts-100281-trimmed.mp3");


var pistol_sprite := load("res://Assets/Sprites/Player/pistolHolder.png")
var rifle_sprite := load("res://Assets/Sprites/Player/rifleHolder.png");
var shotgun_sprite := load("res://Assets/Sprites/Player/shotgunHolder.png");

var knife_hit := load("res://Assets/Audio/knife-stab-pull.mp3");
var knife_miss := load("res://Assets/Audio/knife-slice-41231.mp3");

var idle_sprite := load("res://Assets/Sprites/Player/playerV2.png");

func _ready() -> void:
	print("test")
	self.add_to_group("player");
	load_player();

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		pause();
		
		
	if Input.is_action_just_pressed("dev"):
		take_damage(21);
	
	
	if !is_controllable:
		return;
	
	if (damaging > 0):
		take_damage(_delta * damaging * 5);
	
	if (flashlight.energy != 0):
		# If flashlight is on and has battery left
		if (cur_battery > 0.0):
			cur_battery -= int(_delta * 1000);
		# If flashlight is on but ran out of battery, turn off the flashlight
		else:
			flashlight.energy = 0;
			cur_battery = 0.0;
			
	elif inv["consumable"]["battery"] > 0 && cur_battery < 1:
		cur_battery = MAX_BATTERY;
		inv["consumable"]["battery"] = inv["consumable"]["battery"] - 1;
		# TODO: Play a battery charge/changing sound

	# --- Directional Input ---
	var direction := Input.get_vector("left","right","up","down");
	var movement := 0.0;
	
	
	# --- Character Movement ---
	if Input.is_action_pressed("sprint"):
		movement = SPEED * 1.5;
	else:
		movement = SPEED;
		
	if direction:
		velocity = direction * movement;
	else:
		velocity.x = move_toward(velocity.x, 0, movement);
		velocity.y = move_toward(velocity.y, 0, movement);
		
	if Input.is_action_just_pressed("interact"):
		interact();
		
	if Input.is_action_just_pressed("flashlight") && cur_battery > 0:
		# Play a clicking noise
		if flashlight.energy > 0:
			flashlight.energy = 0;
			return;
		flashlight.energy = 1;

	if Input.is_action_just_pressed("melee"):
		melee();

	if Input.is_action_just_pressed("inventory"):
		if inventory_ui.visible == true:
			inventory_ui.visible = false;
		else:
			inventory_ui.visible = true;
	
	if Input.is_action_just_pressed("heal"):
		heal();
	
	# --- Weapon Controls ---
	if weapons.size() > 0:
		var weapon = weapons[0];
		# if Input.is_action_just_pressed("shoot"):
			# shoot(weapon);
		if (gun_flash.visible == false):
			if Input.is_action_just_pressed("shoot"):
				var result = weapon.shoot(Input.is_action_pressed("aim"), gun);
				
				if (result != null):
					audio_stream_player.stream = weapon.fire_sound;
					audio_stream_player.play(0.15);
					
					## Ensure that enough pellet sparks exist
					while (strike_sparks.get_child_count() < result.size()):
						var n:Node2D = _h_strike_spark.instantiate();
						n.visible = false;
						strike_sparks.add_child(n);
					
					## Ensure that enough pellet blood strikes exist
					while (strike_bloods.get_child_count() < result.size()):
						var n:Node2D = _h_strike_blood.instantiate();
						n.visible = false;
						strike_bloods.add_child(n);
					
					var blood_index:int = 0;
					var spark_index:int = 0;
					for i in result.size():
						## Enable a spark or blood strike at each pellet hit location
						var child;
						if (result[i].hit_npc == false):
							child = strike_sparks.get_child(spark_index);
							spark_index += 1;
						else:
							child = strike_bloods.get_child(blood_index);
							blood_index += 1;
						## Rotate the strike so it looks like it came from the player
						child.global_position = result[i].location;
						child.look_at(self.global_position);
						## Show the strike
						child.visible = true;
					## Show the gun flash
					gun_flash.visible = true;
				else:
					audio_stream_player.stream = weapon.dry_fire_sound;
					audio_stream_player.play();
		## After one frame, disable the gun flash and sparks
		elif (gun_flash.visible):
			## _process renders before each frame
			## if the gun flash is visible it means it must have already rendered once
			for i in strike_sparks.get_child_count():
				strike_sparks.get_child(i).visible = false;
			for i in strike_bloods.get_child_count():
				strike_bloods.get_child(i).visible = false;
			gun_flash.visible = false;
		
		if Input.is_action_just_pressed("reload"):
			reload(weapon);
		if Input.is_action_just_pressed("swap_left"):
			weapons.append(weapons.pop_front());
			print(weapons)
		elif Input.is_action_just_pressed("swap_right"):
			weapons.insert(0, weapons.pop_back());
			print(weapons)

	# --- Sprite Cleanup ---
	# Can move this to the main gun handling later, just doing this for simplicity.
	if weapons.size() > 0:
		if weapons[0].calibur == "pistol":
			player_sprite.texture = pistol_sprite;
			player_sprite.position = Vector2(9.5, 0);
			gun_flash.position =  Vector2(30, 0);
		if weapons[0].calibur == "rifle":
			player_sprite.texture = rifle_sprite;
			player_sprite.position = Vector2(9.5, 0);
			gun_flash.position =  Vector2(30, 5);
		if weapons[0].calibur == "buckshot":
			player_sprite.texture = shotgun_sprite;
			player_sprite.position = Vector2(9.5, 0);
			gun_flash.position =  Vector2(30, 7);
			
	else:
		player_sprite.texture = idle_sprite;
		player_sprite.position = Vector2(0, 0);
	
	# Passes the location of the player to the enemies
	get_tree().call_group("enemy", "player_position", self.global_position);
	# Part of the players object is rotated towards the position of the mouse cursor.
	look.look_at(get_global_mouse_position());
	move_and_slide();

func reload(weapon : Gun) -> void:
	var bullet_type = weapon.calibur;
	if weapon.cur_ammo != weapon.max_ammo and inv["bullet"][bullet_type] != 0:
		inv["bullet"][bullet_type] = inv["bullet"][bullet_type] - weapon.reload(inv["bullet"][bullet_type]); #Could make a variable for inv[][] but it would only be applicable for the last two since you still need to set the value
		audio_stream_player.stream = weapon.reload_sound;
		audio_stream_player.play();

func melee() -> void:
	#https://pixabay.com/sound-effects/search/knife/ -> Knife slice : freesound_community
	#https://pixabay.com/sound-effects/search/knife/ -> kinfe-stab-pull : Karim-Nessim
	for enemy in in_range:
		enemy.take_damage(10);
		audio_stream_player.stream = knife_hit;
		audio_stream_player.play();
		return;
	audio_stream_player.stream = knife_miss;
	audio_stream_player.play();

# --- Inventory ---
func inventory_to_array() -> Array:
	var arr = [];
	var temp_arr;
	
	# --- Weapons to array ---
	for x in range(0,weapons.size()):
		arr.append(weapons[x]);
	for x in range(0,3 - weapons.size()):
		arr += [null];
	
	temp_arr = inv["bullet"].values();
	
	arr.append(load("res://Resources/Items/Bullets/bullet_buckshot.tres").duplicate(true));
	arr[3].amount = temp_arr[0];
	arr.append(load("res://Resources/Items/Bullets/bullet_pistol.tres").duplicate(true));
	arr[4].amount = temp_arr[1];
	arr.append(load("res://Resources/Items/Bullets/bullet_rifle.tres").duplicate(true));
	arr[5].amount = temp_arr[2];

	temp_arr = inv["consumable"].values();
	arr.append(load("res://Resources/Items/Consumables/battery.tres").duplicate(true));
	arr[6].amount = temp_arr[0];
	arr.append(load("res://Resources/Items/Consumables/medkit.tres").duplicate(true));
	arr[7].amount = temp_arr[1];
	
	temp_arr = inv["crafting"].values();
	arr.append(load("res://Resources/Items/Crafting Materials/duct_tape.tres").duplicate(true));
	arr[8].amount = temp_arr[0];
	arr.append(load("res://Resources/Items/Crafting Materials/metal_pipe.tres").duplicate(true));
	arr[9].amount = temp_arr[1];
	arr.append(load("res://Resources/Items/Crafting Materials/scrap.tres").duplicate(true));
	arr[10].amount = temp_arr[2];
	arr.append(load("res://Resources/Items/Crafting Materials/screw.tres").duplicate(true));
	arr[11].amount = temp_arr[3];
	
	
	for x in range(0,inv["key"].size()):
		arr.append(load("res://Resources/Items/key.tres").duplicate(true));
	return arr;


# --- Interaction Functions ---
func interact() -> void:
	if interactions:
		var cur_interaction = interactions[0];
		var interaction_node = cur_interaction.interact_node;
		
		# Look at interactable.gd if you nee to see the interaction types
		match cur_interaction.interact_type:
			0:# Pick up item
				# This is just for keys, essentially it adds a node to your inventory
				if interaction_node != null:
					# TODO: Might rework this in the future before the submission date, this was a hacky solution
					inv["key"].append(cur_interaction.interact_node);
					cur_interaction.hide();
					cur_interaction.set_collision_layer_value(4, false);
					return;
				
				var res_name = cur_interaction.interact_resource["name"];
				var res_type = cur_interaction.interact_resource["type"];
				var res_amount = cur_interaction.interact_resource["amount"];
				
				if inv[res_type].has(res_name):
					inv[res_type][res_name] = (inv[res_type][res_name] + res_amount);
				else:
					inv[res_type][res_name] = res_amount;
				cur_interaction.remove();

			1: # Pickup gun
				if weapons.size() < 3:
					weapons.insert(weapons.size(), cur_interaction.interact_resource.duplicate(true));
					cur_interaction.remove();
				else:
					interact_label.text = "I can't hold anymore weapons."
					timer.start();

			2: # Open door
				if interaction_node in inv["key"]:
					inv["key"].erase(interaction_node);
					cur_interaction.get_parent().interact();
				elif interaction_node == null:
					cur_interaction.get_parent().interact();
				else:
					interact_label.text = "The door is locked";
			3: # TODO: If I have time find a way to shut off ALL lights so it isn't bleeding into the overlay. (get_parent().find_children
				upgrade_ui.selected_upgrade.clear();
				is_controllable = false;
				upgrade_ui.visible = true;
				upgrade_ui.weapon_array = weapons;
				upgrade_ui.resources = inv["crafting"];
				upgrade_ui.update_ui();
				
			"_":
				print("Something went horribly wrong.")

func _on_interaction_area_entered(area: Area2D) -> void:
	# Add the interaction area that entered the players interaction sphere to an array
	interactions.insert(0, area);
	update_interactions();

func _on_interaction_area_exited(area: Area2D) -> void:
	# Remove interaction from the array when the areas are no loger colliding
	interactions.erase(area);
	update_interactions();

func update_interactions() -> void:
	if interactions:
		interact_label.text = interactions[0].interact_label;
	else:
		interact_label.text = "";

# --- Handling Player Damage ---
func take_damage(damage : float) -> void:
	cur_health -= damage;
	if cur_health <= 0:
		cur_health = 0;
		die();
	else:
		if !audio_stream_player2.is_playing():
			audio_stream_player2.stream = _damage_stx;
			audio_stream_player2.play();


func die() -> void:
	SceneLoader.switch_scene("res://UI/Menus/death_screen.tscn");

func heal() -> void:
	if inv["consumable"].has("medkit") && inv["consumable"]["medkit"] > 0 && cur_health != MAX_HEALTH:
		cur_health = MAX_HEALTH;
		inv["consumable"]["medkit"] -= 1;

# --- Save and Load Data ---
func load_player() -> void:
	SaveLoad.load_player_data();
	var saved_data = SaveLoad.player_data;
	cur_health = saved_data["cur_health"];
	cur_battery  = saved_data["cur_battery"];
	inv = saved_data["inventory"];
	weapons = saved_data["weapons"];

func save_player(level_path : String) -> PlayerData:
	var new_player = PlayerData.new();
	
	new_player["cur_level_path"] = level_path;
	new_player["cur_health"] = cur_health;
	new_player["cur_battery"] = cur_battery;
	new_player["inventory"] = inv;
	new_player["weapons"] = weapons;
	
	return new_player;

func _on_timer_timeout() -> void:
	interact_label.text = "";


func _on_knife_body_entered(body: Node2D) -> void:
	if body is Enemy:
		in_range.insert(0, body);

func _on_knife_body_exited(body: Node2D) -> void:
	if body is Enemy:
		in_range.erase(body);

func _on_damage_area_entered(area: Area2D) -> void:
	print("Entered")
	if (area.get_parent() is Enemy):
		damaging += 1;

func _on_damage_area_exited(area: Area2D) -> void:
	print("Exited")
	if (area.get_parent() is Enemy):
		damaging -= 1;

func pause():
	if is_controllable:
		Engine.time_scale = 0;
		is_controllable = false;
		pause_menu.visible = true;
		return;
	Engine.time_scale = 1;
	is_controllable = true;
	pause_menu.visible = false;
