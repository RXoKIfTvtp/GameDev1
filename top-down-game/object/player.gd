extends CharacterBody2D

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass

func _on_entered(area: Area2D) -> void:
	print("Ouch: " + str(area));
	pass
