extends Node2D

var is_one_button : bool = true
var double_tap : float = 0.25
var direction : bool = true
var waiting_tap : bool = false

@onready var timer : Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_one_button == true:
		$Sprite2D2.show()
	GlobalSettings.settings_changed.connect(settings)
	settings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if direction == true:
		$Sprite2D2.rotation = 0
	else:
		$Sprite2D2.rotation = deg_to_rad(180)
	
	if is_one_button == false:
		if Input.is_action_pressed("Up"):
			self.position.y += -350 * delta
		if Input.is_action_pressed("Down"):
			self.position.y += 350 * delta

	elif is_one_button == true:

		if Input.is_action_just_pressed("Up"):
			if waiting_tap == true:
				waiting_tap = false
				if direction == true:
					direction = false
				else:
					direction = true
			tap_timer()
		
		if Input.is_action_pressed("Up"):
			if direction == true:
				self.position.y += -350 * delta
			else:
				self.position.y += 350 * delta

	position.y = clamp(position.y, 128, 592)

func tap_timer():
	waiting_tap = true
	timer.wait_time = double_tap
	timer.start()


func _on_timer_timeout() -> void:
	waiting_tap = false

@onready var carTexture=[preload("res://Sprites/Racing game/Car variants/voiture_normal.png"),
						 preload("res://Sprites/Racing game/Car variants/voiture_blanc.png"),
						 preload("res://Sprites/Racing game/Car variants/voiture_bleu.png"),
						 preload("res://Sprites/Racing game/Car variants/voiture_jaune.png"),
						 preload("res://Sprites/Racing game/Car variants/voiture_noir.png"),
						 preload("res://Sprites/Racing game/Car variants/voiture_rouge.png"),
						 preload("res://Sprites/Racing game/Car variants/voiture_vert.png"),]

func settings():
	var game=get_parent()
	var road=game.get_node("Road")
	$Sprite.texture=carTexture[GlobalSettings.player_color]
	if GlobalSettings.darkerBackground:
		if road.get_node("Sprite").modulate==Color.WHITE:
			road.get_node("Sprite").modulate=Color.DIM_GRAY
			game.get_node("Grass/Sprite").modulate=Color.DIM_GRAY
	else:
		if road.get_node("Sprite").modulate==Color.DIM_GRAY:
			road.get_node("Sprite").modulate=Color.WHITE
			game.get_node("Grass/Sprite").modulate=Color.WHITE
	is_one_button = GlobalSettings.one_button_mode
	print(is_one_button)
	if is_one_button == true:
		$Sprite2D2.show()
	else:
		$Sprite2D2.hide()
	Engine.time_scale = GlobalSettings.car_timescale
