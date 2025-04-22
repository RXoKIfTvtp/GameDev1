extends Node2D

@export var resource : Resource;

@onready var sprite = $Sprite2D;
@onready var amount_lb = $AmountLabel;

func update() -> void:
	if resource != null:
		sprite.texture = resource.icon;
		
		if resource is Gun:
			if resource.calibur != "pistol":
				sprite.scale = Vector2(1,1);
			amount_lb.text = "";
		else:
			amount_lb.text = str(resource.amount);
	else:
		sprite.texture = null;
