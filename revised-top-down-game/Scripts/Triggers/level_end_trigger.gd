class_name LevelEndTrigger extends Area2D

@export var next_scene := "res://Levels/dev_level.tscn";

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SaveLoad.save_player_data(body.save_player(next_scene))
		SceneLoader.switch_scene(next_scene);
