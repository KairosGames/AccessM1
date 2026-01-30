extends Sprite2D

func settingsRefresh()->void:
	if GlobalSettings.darkerBackground:
		if modulate==Color.WHITE:
			modulate=Color.DIM_GRAY
	else:
		if modulate==Color.DIM_GRAY:
			modulate=Color.WHITE
			
func _ready() -> void:
	GlobalSettings.settings_changed.connect(settingsRefresh)
