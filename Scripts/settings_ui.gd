extends CanvasLayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		if self.visible == false:
			self.show()
			Engine.time_scale = 0
		else:
			self.hide()
			Engine.time_scale = 1
			GlobalSettings.new_settings()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_quit_menu_pressed() -> void:
	self.hide()
	Engine.time_scale = 1
	GlobalSettings.new_settings()
