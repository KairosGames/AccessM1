extends TabBar

func _on_h_slider_value_changed(value: float) -> void:
	GlobalSettings.car_timescale = value

func _on_bebou_mode_toggled(toggled_on: bool) -> void:
	GlobalSettings.bebou_mode = toggled_on

func _on_one_button_mode_toggled(toggled_on: bool) -> void:
	GlobalSettings.one_button_mode = toggled_on
