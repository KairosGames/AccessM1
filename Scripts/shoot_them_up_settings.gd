extends TabBar

func _on_invincibility_toggled(toggled_on: bool) -> void:
	GlobalSettings.invincibility=toggled_on
	GlobalSettings.new_settings()

func _on_autofire_toggled(toggled_on: bool) -> void:
	GlobalSettings.autofire=toggled_on
	GlobalSettings.new_settings()

func _on_h_slider_value_changed(value: float) -> void:
	if value!=GlobalSettings.shmup_timescale:
		GlobalSettings.shmup_timescale=value
		GlobalSettings.new_settings()
		$VBoxContainer2/TimeScale/Label.text="Time Scale "+str(floori(value*100))+"%"

func _on_player_projectile_speed_toggled(toggled_on: bool) -> void:
	GlobalSettings.playerProjectileSpeed=toggled_on
	GlobalSettings.new_settings()

func _on_enemy_projectile_speed_toggled(toggled_on: bool) -> void:
	GlobalSettings.enemyProjectileSpeed = toggled_on
	GlobalSettings.new_settings()

func _on_dark_background_toggled(toggled_on: bool) -> void:
	GlobalSettings.darkerBackground=toggled_on
	GlobalSettings.new_settings()
