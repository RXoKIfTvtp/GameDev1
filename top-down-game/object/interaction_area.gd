class_name Interactable extends Area2D

@export var interact_label := "none";
@export var interact_type := "none";
@export var interact_value : Node2D;

func remove() -> void:
	queue_free();
