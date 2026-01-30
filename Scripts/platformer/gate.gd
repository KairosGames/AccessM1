extends Area2D

func _ready() -> void:
	GlobalSettings.settings_changed.connect(settings)
	settings()
	
func settings()->void:
	match floori(GlobalSettings.player_color):
		0:
			modulate=Color.WHITE
		1:
			modulate=Color(1.5,1.5,1.5)
		2:
			modulate=Color(0.75,0.75,1.5)
		3:
			modulate=Color(1.25,1.25,0.75)
		4:
			modulate=Color(0.5,0.5,0.5)
		5:
			modulate=Color(1.5,0.75,.75)
		6:
			modulate=Color(0.75,1.5,0.75)
