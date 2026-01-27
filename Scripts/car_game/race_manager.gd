extends Node2D

@export var obstacles : Array[PackedScene]

func _ready() -> void:
	obstacle_timer()
	race_timer()

func obstacle_timer():
	await get_tree().create_timer(randf_range(1, 3)).timeout
	spawn_obstacle()

func race_timer():
	await get_tree().create_timer(25).timeout
	var end : Area2D = obstacles.get(1).instantiate()
	add_child(end)

func spawn_obstacle():
	var new_obstacle : Area2D = obstacles.get(0).instantiate()
	new_obstacle.position.y += randf_range(-300, 300)
	add_child(new_obstacle)
	obstacle_timer()
