extends Area2D

@export var death_texture : Array[Texture2D]=[preload("res://Assets/chat 2.png"),
											  preload("res://Sprites/Racing game/Cats variants/Ecrasé/chat_2_blanc.png"),
											  preload("res://Sprites/Racing game/Cats variants/Ecrasé/chat_2_bleu.png"),
											  preload("res://Sprites/Racing game/Cats variants/Ecrasé/chat_2_jaune.png"),
											  preload("res://Sprites/Racing game/Cats variants/Ecrasé/chat_2_noir.png"),
											  preload("res://Sprites/Racing game/Cats variants/Ecrasé/chat_2_rouge.png"),
											  preload("res://Sprites/Racing game/Cats variants/Ecrasé/chat_2_vert.png")]
@export var base_texture : Array[Texture2D]=[preload("res://Assets/chat 1.png"),
											preload("res://Sprites/Racing game/Cats variants/Debout/chat_1_blanc.png"),
											preload("res://Sprites/Racing game/Cats variants/Debout/chat_1_bleu.png"),
											preload("res://Sprites/Racing game/Cats variants/Debout/chat_1_jaune.png"),
											preload("res://Sprites/Racing game/Cats variants/Debout/chat_1_noir.png"),
											preload("res://Sprites/Racing game/Cats variants/Debout/chat_1_rouge.png"),
											preload("res://Sprites/Racing game/Cats variants/Debout/chat_1_vert.png"),]
@export var bebou_texture : Texture2D=preload("res://Assets/Chocolatine.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation_degrees=randf_range(0,360)
	GlobalSettings.settings_changed.connect(change_sprite)
	change_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x += -1000 * delta

func _on_body_entered(_body: Node2D) -> void:
	if GlobalSettings.bebou_mode:
		$GetChicksSound.play()
		$Sprite2D.visible = false
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
	else:
		rotation_degrees=randf_range(0,360)
		$Sprite2D.texture = death_texture[GlobalSettings.other_color]
		$Cat_Smashed.play()
		$Cat_Destroyed.play()

func change_sprite():
	if GlobalSettings.bebou_mode:
		$Sprite2D.texture = bebou_texture
		$Sprite2D.scale = Vector2(0.2, 0.2)
		match floori(GlobalSettings.other_color):
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
	else:
		$Sprite2D.texture = base_texture[GlobalSettings.other_color]
		$Sprite2D.scale = Vector2(0.2, 0.2)
