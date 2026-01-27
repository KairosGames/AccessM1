extends Node2D

class_name Shmup

@onready var bulletModel=preload("res://Prefabs/bullet.tscn")
@onready var enemyModel=preload("res://Prefabs/enemy_shmup.tscn")

func play(sound:AudioStream,where=Vector2(0,0)):
	get_parent().AudioManager.play(sound,where)

func playPool(sounds:Array[AudioStream],where=Vector2(0,0)):
	get_parent().play(sounds.pick_random(),where)

const DATA={
	"PLAYER":{
		"SPEED":100, # Pixels per second
		"FRICTION":10 # Pixels per second
	},
	"ENEMY":{
		"PERIOD":1,# spawn period
		"VELOCITY":-1000, # Pixels per second
		"SPRITE":preload("res://Sprites/HereItComes.png"),
		"SCALE":0.2,
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

var spawnTimer=DATA.ENEMY.PERIOD

func _process(delta: float) -> void:
	spawnTimer-=delta
	while spawnTimer<=0:
		spawn(DATA.ENEMY,Vector2(1800,randf_range(60,660)))
		spawnTimer+=DATA.ENEMY.PERIOD

func spawn(what,where:Vector2)->void:
	var e=enemyModel.instantiate()
	e.call_deferred("setModel",what,where)
	add_child(e)
