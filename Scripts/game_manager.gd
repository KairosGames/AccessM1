class_name GameManager extends Node2D

@export var games : Array[PackedScene] = []

var currentIndex: int = 0
var currentGame: Node2D

func _ready() -> void:
	currentGame = games[currentIndex].instantiate()
	add_child(currentGame)
	pass

func next_game() -> void:
	if currentIndex == games.size() - 1:
		get_tree().quit()
		return
	
	var toDelete: Node2D = currentGame
	toDelete.queue_free()
	currentIndex += 1
	currentGame = games[currentIndex].instantiate()
	add_child(currentGame)
	
