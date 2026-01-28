extends Node

var to_print : String

@export var line : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalCc.ui = self

func add_line(sound_name, sound_position):
	print(sound_position)
	var new_line : HBoxContainer = line.instantiate()
	if sound_position < float(0):
		new_line.get_child(0).show()
	to_print = to_print + sound_name
	if sound_position > float(0):
		new_line.get_child(2).show()
	new_line.get_child(1).text = sound_name
	$CanvasLayer/VBoxContainer.add_child(new_line)
