extends Node2D

class_name Shmup

@onready var bulletModel=preload("res://Prefabs/bullet.tscn")
@onready var enemyModel=preload("res://Prefabs/enemy_shmup.tscn")

const RESTART_TIME=3

@export var player: CharacterBody2D
@onready var playerModel=preload("res://Prefabs/player_shmup.tscn")
var startPosition=Vector2(100,100)

var restart:float=0

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
		"SPRITE":preload("res://Sprites/ennemi 2.png"),
		"SCALE":0.1,
		"SCORE":10,
	},
	"BULLET":{
		"PLAYER":{
			"FRIEND":true,
			"VELOCITY":1500,
			"SPRITE":preload("res://Sprites/bullet joueur.png"),
			"SCALE":0.4,
			"OFFSET":Vector2(32,0)
		},
		"ENEMY":{
			"FRIEND":false,
			"VELOCITY":-100,
			"SPRITE":preload("res://Sprites/bullet ennemi.png"),
			"SCALE":0.2
		}
	}
}

func _ready() -> void:
	await get_tree().create_timer(20.0).timeout
	get_parent().next_game()
	
	pass#set_deferred("startPositin",player.global_position)

var spawnTimer=DATA.ENEMY.PERIOD
var playerDead=false

func _process(delta: float) -> void:
	if playerDead:
		var gm: GameManager = get_parent()
		gm.currentIndex -= 1
		get_parent().next_game()
		if restart==RESTART_TIME:
			$Camera/EndPanel.visible=true
			for c in get_children():
				print(c.name)
				if c.name.contains("Enemy"):
					c.queue_free()
		restart-=delta
		$Camera/EndPanel/EndLabel.text="You died\nRestart in... "+str(ceil(restart))
		if restart<=0:
			playerDead=false
			print("RESPAWN")
			player=playerModel.instantiate()
			player.set_deferred("global_position",startPosition)
			add_child(player)
			restart=RESTART_TIME
			scoreSet(0)
			spawnTimer=DATA.ENEMY.PERIOD
			$Camera/EndPanel.visible=false
	else:
		restart=RESTART_TIME
		spawnTimer-=delta
		while spawnTimer<=0:
			spawn(DATA.ENEMY,Vector2(1800,randf_range(60,660)))
			spawnTimer+=DATA.ENEMY.PERIOD
			

func spawn(what,where:Vector2)->void:
	var e=enemyModel.instantiate()
	e.call_deferred("setModel",what,where)
	add_child(e)

var score:int=0

func scoreSet(what):
	score=what
	$Camera/Panel/Label.text="Score "+str(score)

func scoreAdd(what):
	scoreSet(score+what)
