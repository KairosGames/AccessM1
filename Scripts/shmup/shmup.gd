extends Node2D

class_name Shmup

@onready var bulletModel=preload("res://Prefabs/shmup/bullet.tscn")
@onready var enemyModel=preload("res://Prefabs/shmup/enemy_shmup.tscn")

const RESTART_TIME=3

@export var player: CharacterBody2D
@onready var playerModel=preload("res://Prefabs/shmup/player_shmup.tscn")
var startPosition=Vector2(100,100)

var restart:float=0

@export var scoreMultiplier:float=1
@export var gameSpeed:float=1
@export var invincible:bool=false

func play(sound:AudioStream,where=Vector2(0,0)):
	get_parent().AudioManager.play(sound,where)

func playPool(sounds:Array[AudioStream],where=Vector2(0,0)):
	get_parent().play(sounds.pick_random(),where)

const DATA={
	"PLAYER":{
		"SPEED":100, # Pixels per second
		"FRICTION":10, # Pixels per second
		"LIFE":10
	},
	"ENEMY":{
		"PERIOD":1,# spawn period
		"VELOCITY":-1000, # Pixels per second
		"SPRITE":preload("res://Sprites/shmup/ennemi 2.png"),
		"SCALE":0.1,
		"COLLISION":32,#Radius
		"SCORE":10,
		"LIFE":1,
		"DAMAGE":2 # on player collision
	},
	"ENEMYBIG":{
		"PERIOD":3.5,# spawn period
		"VELOCITY":-500, # Pixels per second
		"SPRITE":preload("res://Sprites/shmup/ennemi 2.png"),
		"SCALE":0.2,
		"COLLISION":64,#Radius
		"SCORE":10,
		"LIFE":5,
		"DAMAGE":5 # on player collision
	},
	"BULLET":{
		"PLAYER":{
			"FRIEND":true,
			"VELOCITY":1500,
			"SPRITE":preload("res://Sprites/shmup/bullet joueur.png"),
			"SCALE":0.4,
			"OFFSET":Vector2(64,0),
			"LIFE":1, # Number of hits before destruction
			"DAMAGE":1, # Damage per hit
			"COLLISION":8 #Radius
		},
		"ENEMY":{
			"FRIEND":false,
			"VELOCITY":-100,
			"SPRITE":preload("res://Sprites/shmup/bullet ennemi.png"),
			"SCALE":0.2,
			"LIFE":1,
			"DAMAGE":1,
			"COLLISION":8#Radius
		}
	}
}

func _ready() -> void:
	player.life=DATA.PLAYER.LIFE
	if invincible:
		player.collision_mask=16
	Engine.time_scale=gameSpeed
	startPosition=player.global_position
	#await get_tree().create_timer(20.0).timeout
	#get_parent().next_game()
	#Engine.time_scale=1
	#pass#set_deferred("startPositin",player.global_position)

var spawnTimer=DATA.ENEMY.PERIOD
var spawnBigTimer=DATA.ENEMYBIG.PERIOD
var playerDead=false

var invincibilityPressed:bool=false

var gameSpeeds=[0.25,0.5,0.75,1]
var gameSpeedIndex=3
var gameSpeedPressed:bool=false

func _process(delta: float) -> void:
	if Input.get_action_raw_strength("Shmup_Invincibility"):
		if not invincibilityPressed:
			invincibilityPressed=true
			invincibleSet(not invincible)
	else:
		invincibilityPressed=false
	if Input.get_action_raw_strength("Shmup_game_speed"):
		if not gameSpeedPressed:
			gameSpeedPressed=true
			gameSpeedIndex+=1
			if gameSpeedIndex>=gameSpeeds.size():
				gameSpeedIndex=0
			Engine.time_scale=gameSpeeds[gameSpeedIndex]
	else:
		gameSpeedPressed=false
	if playerDead:
		#var gm: GameManager = get_parent()
		#gm.currentIndex -= 1
		#get_parent().next_game()
		 #Engine.time_scale=gameSpeed
		if restart==RESTART_TIME:
			player.visible=false
			$Camera/EndPanel.visible=true
			for c in get_children():
				if c.name.contains("Enemy") or c.name.contains("Bullet"):
					c.queue_free()
		restart-=delta
		$Camera/EndPanel/EndLabel.text="You died\nRestart in... "+str(ceili(restart))
		if restart<=0: # GAME RESTARTS
			player.global_position=startPosition
			player.visible=true
			playerDead=false
			player.life=DATA.PLAYER.LIFE
			restart=RESTART_TIME
			scoreSet(0)
			spawnTimer=DATA.ENEMY.PERIOD
			$Camera/EndPanel.visible=false
	else:
		restart=RESTART_TIME
		spawnTimer-=delta
		spawnBigTimer-=delta
		while spawnTimer<=0:
			spawn(DATA.ENEMY,Vector2(1800,randf_range(60,660)))
			spawnTimer+=DATA.ENEMY.PERIOD
		while spawnBigTimer<=0:
			spawn(DATA.ENEMYBIG,Vector2(1800,randf_range(60,660)))
			spawnBigTimer+=DATA.ENEMYBIG.PERIOD

func spawn(what,where:Vector2)->void:
	var e=enemyModel.instantiate()
	e.call_deferred("setModel",what,where)
	add_child(e)

var score:float=0

func scoreSet(what:float):
	score=what
	$Camera/Panel/Label.text="Score "+str(floori(score))

func scoreAdd(what:float):
	scoreSet(score+what*scoreMultiplier)

func invincibleSet(value:bool)->void:
	if value!=invincible:
		invincible=value
		if value:
			player.collision_mask=16 # Just world border
			for e in get_children():
				if e.name.contains("Bullet") and not e.friend:
					e.collision_mask=2
				if e.name.contains("Enemy"):
					e.collision_mask=2
		else:
			player.collision_mask=4+8+16
			for e in get_children():
				if e.name.contains("Bullet") and not e.friend:
					e.collision_mask=1+2
				if e.name.contains("Enemy"):
					e.collision_mask=1+2
