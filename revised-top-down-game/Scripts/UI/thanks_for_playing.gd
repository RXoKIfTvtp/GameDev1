extends Control

@onready var timer := $Timer;

func _ready() -> void:
	timer.start();


func _on_timer_timeout() -> void:
	SceneLoader.switch_scene("res://UI/main_menu.tscn");
