class_name Enemy extends CharacterBody2D

@export var health:= 0;
@onready var corpse := load("res://Objects/Enemies/zombie_corpse.tscn");

func die():
	var instance = corpse.instantiate();
	get_tree().get_current_scene().add_child(instance);
	instance.global_position = global_position;
	instance.rotation = rotation;
	queue_free();

func take_damage(damage: int):
	# TODO: Make noise when damaged

	health -= damage;
	print("This enemy took " + str(damage) + " damage. They have " + str(health) + " remaining.")
	
	if health <= 0:
		die()
