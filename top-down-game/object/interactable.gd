class_name Interactable extends Area2D


enum Interaction_Types{
	PICKUP_ITEM,
	PICKUP_WEAPON,
	OPEN_UNLOCKED_DOOR,
	OPEN_LOCKED_DOOR
}


@export var interact_label := "none";
@export var interact_type : Interaction_Types;
@export var interact_value : Node2D;

func remove() -> void:
	queue_free();
