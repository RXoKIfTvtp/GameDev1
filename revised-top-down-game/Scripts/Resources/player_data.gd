class_name PlayerData extends Resource

@export var cur_level_path := "res://Levels/PlayGround.tscn";

@export var cur_health := 100;

@export var battery_level := 0;

@export var bullets := {
	"pistol":999,
	"rifle":999,
	"buckshot":999
};
	
@export var inventory := {
	"bullet" : {
		"pistol":999,
		"rifle":999,
		"buckshot":999
	},
	"consumable": {
		
	},
	"scrap" : {
		
	},
	"key" : []
};

@export var weapons := [];
