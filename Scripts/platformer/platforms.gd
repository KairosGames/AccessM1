extends Node2D

@onready var platformTexture:Array[Texture2D]=[preload("res://Sprites/Plateformer/platforms variants/plateforme_normal.png"),
											   preload("res://Sprites/Plateformer/platforms variants/plateforme_blanc.png"),
											   preload("res://Sprites/Plateformer/platforms variants/plateforme_bleu.png"),
											   preload("res://Sprites/Plateformer/platforms variants/plateforme_jaune.png"),
											   preload("res://Sprites/Plateformer/platforms variants/plateforme_noir.png"),
											   preload("res://Sprites/Plateformer/platforms variants/plateforme_rouge.png"),
											   preload("res://Sprites/Plateformer/platforms variants/plateforme_vert.png")]

func _ready() -> void:
	GlobalSettings.settings_changed.connect(settings)
	settings()
	
func settings()->void:
	for e in get_children():
		e.get_node("Sprite2D").texture=platformTexture[GlobalSettings.other_color]
