extends TabBar



func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalSettings.auto_jump = true
	else:
		toggled_on = false
	GlobalSettings.new_settings()


func _on_h_slider_value_changed(value: float) -> void:
	GlobalSettings.coyote_time = value
	GlobalSettings.new_settings()
