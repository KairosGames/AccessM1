extends Node

var to_print : String
var container : VBoxContainer

@export var line : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalCc.ui = self
	container = $CanvasLayer/VBoxContainer

func add_line(sound_name, sound_position):
	var new_line : HBoxContainer = line.instantiate()
	if sound_position.x < float(360):
		new_line.get_child(0).show()
	to_print = to_print + sound_name
	if sound_position.x > float(360):
		new_line.get_child(2).show()
	new_line.get_child(1).text = sound_name
	new_line.name = sound_name
	$CanvasLayer/VBoxContainer.add_child(new_line)

func remove_line(sound_name):
	for i in container.get_children():
		if i.name.contains(sound_name):
			i.queue_free()

func erase_all():
	for i in container.get_children():
		i.queue_free()
