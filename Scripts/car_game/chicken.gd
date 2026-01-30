extends Area2D

@export var death_texture : Texture2D
@export var base_texture : Texture2D
@export var bebou_texture : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSettings.settings_changed.connect(change_sprite)
	change_sprite()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x += -1000 * delta

func _on_body_entered(_body: Node2D) -> void:
	if GlobalSettings.bebou_mode == true:
		$GetChicksSound.play()
		$Sprite2D.visible = false
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
	else:
		$Sprite2D.texture = death_texture
		$Cat_Smashed.play()
		$Cat_Destroyed.play()

func change_sprite():
	if GlobalSettings.bebou_mode == true:
		$Sprite2D.texture = bebou_texture
		$Sprite2D.scale = Vector2(0.2, 0.2)
	else:
		$Sprite2D.texture = base_texture
		$Sprite2D.scale = Vector2(0.2, 0.2)
