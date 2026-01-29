extends Area2D


func _physics_process(delta: float) -> void:
	position.x += -1000 * delta
	

func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 1
	(get_parent().get_parent().get_parent() as GameManager).next_game()
