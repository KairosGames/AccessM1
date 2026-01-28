class_name JumpBox extends Area2D

@export var time: float

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerPlatformer:
		var player: PlayerPlatformer = body as PlayerPlatformer
		player.launch_auto_jump()
