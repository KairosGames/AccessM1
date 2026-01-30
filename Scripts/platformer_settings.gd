extends TabBar

func _on_check_box_toggled(toggled_on: bool) -> void:
	GlobalSettings.auto_jump = not toggled_on
	GlobalSettings.new_settings()
	Engine.time_scale=0

func _on_h_slider_value_changed(value: float) -> void:
	GlobalSettings.coyote_time=value
	GlobalSettings.new_settings()
	Engine.time_scale=0
