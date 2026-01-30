extends Control

var master_bus
var stereo

func _ready() -> void:
	master_bus = AudioServer.get_bus_index("Master")
	stereo = AudioServer.get_bus_effect(master_bus, 0)
	AudioServer.set_bus_bypass_effects(master_bus, true)

func _on_mute_all_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)

func _on_mono_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_bypass_effects(master_bus, false)
	else:
		AudioServer.set_bus_bypass_effects(master_bus, true)


func _on_general_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, value)
