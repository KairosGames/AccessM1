extends Node

var game_manager : GameManager
var emitters : Array[AudioStreamPlayer2D]
var ui


# Called when the node enters the scene tree for the first time.
func _ready() -> void: pass

func update_emitters():
	emitters.clear()

func write(sound_name, position):
	print(sound_name, position)
	ui.add_line(sound_name, position)
