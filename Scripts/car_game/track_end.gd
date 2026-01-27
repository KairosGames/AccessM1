extends Area2D


func _process(_delta: float) -> void:
	position.x += -20

func _on_body_entered(body: Node2D) -> void:
	if "game_manager" in body and body.game_manager != null:
		body.game_manager.next_game()
