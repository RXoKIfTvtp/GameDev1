class_name Item extends Resource

@export var name : String;
@export_enum( #Will think over what need to be included later
	"bullet",
	"crafting",
	"consumable",
	"key"
) var type : String;
@export var icon : Texture2D;
@export var amount : int;
#@export var path : String;
