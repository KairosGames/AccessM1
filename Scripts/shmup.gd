extends Node2D

class_name Shmup

@onready var bulletModel=preload("res://Prefabs/bullet.tscn")
const DATA={
	"PLAYER":{
		"SPEED":100, # Pixels per second
		"FRICTION":10 # Pixels per second
	},
	"BULLET":{
		"PLAYER":{
			"FRIEND":true,
			"VELOCITY":1500,
			"SPRITE":preload("res://Sprites/pogflame.png"),
			"SCALE":0.1,
			"OFFSET":Vector2(32,0)
		},
		"ENEMY":{
			"FRIEND":false,
			"VELOCITY":-100,
			"SPRITE":preload("res://Sprites/pogflame.png"),
			"SCALE":0.1
		}
	}
}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
