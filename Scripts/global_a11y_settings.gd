extends TabBar

var white := Color(255, 255, 255)
var blue := Color(0, 0, 155)
var yellow := Color(155, 155, 0)
var black := Color()
var red := Color(155, 0, 0)
var green := Color(0, 155, 0)
var colors = [null ,white, blue, yellow, black, red, green]

@onready var player_sprite : TextureRect = $VBoxContainer2/PlayerColor/TextureRect
@onready var enemy_sprite : TextureRect = $VBoxContainer2/EnemyColor/TextureRect

func _on_dark_background_toggled(toggled_on: bool) -> void:
	GlobalSettings.darkerBackground=toggled_on
	GlobalSettings.new_settings()
	Engine.time_scale = 0

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
		$VBoxContainer2/PlayerColor/VBoxContainer/Label.text="Player color : "+s
		if value != 0:
			player_sprite.self_modulate = colors.get(value)
		Engine.time_scale = 0

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
		$VBoxContainer2/EnemyColor/VBoxContainer/Label.text="Enemy color : "+s
		if value != 0:
			enemy_sprite.self_modulate = colors.get(value)
		Engine.time_scale = 0
