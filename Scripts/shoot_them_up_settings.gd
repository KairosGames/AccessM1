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
	Engine.time_scale=0

func _on_player_color_value_changed(value: float) -> void:
	if value!=GlobalSettings.shmup_player_color:
		GlobalSettings.shmup_player_color=value
		GlobalSettings.new_settings()
		var s="Standard"
		match floori(value):
			1:
				s="White"
			2:
				s="Blue"
			3:
				s="Yellow"
			4:
				s="Black"
			5:
				s="Red"
			6:
				s="Green"
		$VBoxContainer2/PlayerColor/Label.text="Player color : "+s

func _on_enemy_color_value_changed(value: float) -> void:
	if value!=GlobalSettings.shmup_enemy_color:
		GlobalSettings.shmup_enemy_color=value
		GlobalSettings.new_settings()
		var s="Standard"
		match floori(value):
			1:
				s="White"
			2:
				s="Blue"
			3:
				s="Yellow"
			4:
				s="Black"
			5:
				s="Red"
			6:
				s="Green"
		$VBoxContainer2/EnemyColor/Label.text="Enemy color : "+s
