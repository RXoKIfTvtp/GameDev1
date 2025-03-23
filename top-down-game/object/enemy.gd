class_name Enemy extends CharacterBody2D

@export var health := 0;

func take_damage(damage : int):
	# TODO: Make noise when damaged
	print("This enemy took " + str(damage) + "damage. They have " + str(health) + " remaining.")
	health -= damage;
	
	if health <= 0:
		die()

func die():
	#TODO: Spawn body at the enemies current location
	queue_free();
