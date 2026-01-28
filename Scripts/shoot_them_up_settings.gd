extends TabBar

func _on_invincibility_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalSettings.invincibility = true
		
	else:
		GlobalSettings.invincibility = false
	GlobalSettings.new_settings()

func _on_autofire_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalSettings.autofire = true
	else:
		GlobalSettings.autofire = false
	GlobalSettings.new_settings()
