extends TabBar

func _on_h_slider_value_changed(value: float) -> void:
	GlobalSettings.car_timescale = value



func _on_bebou_mode_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalSettings.bebou_mode = true
	else:
		GlobalSettings.bebou_mode = false
	GlobalSettings.new_settings()

func _on_one_button_mode_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalSettings.one_button_mode = true
	else:
		toggled_on = false
		GlobalSettings.one_button_mode = false
	GlobalSettings.new_settings()
