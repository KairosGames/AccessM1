extends Node

var game_manager : GameManager
var emitters : Array[AudioStreamPlayer2D]
var ui
var localised_mode : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void: pass

func update_emitters():
	emitters.clear()
	ui.erase_all()

func erase(sound_name):
	ui.remove_line(sound_name)

func write(sound_name, position):
	ui.add_line(sound_name, position)
