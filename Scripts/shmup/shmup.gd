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
# Projectile types : 
# FRONT fire in front
# TARGET fire the player position
# BALISTICS fire where the player can be

const DATA={
	"PLAYER":{
		"SPEED":100, # Pixels per second
		"FRICTION":10, # Pixels per second
		"LIFE":10, # Pixels per second
		"RELOAD":0.25 # To fire, in seconds
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
		"PERIOD":6.19,# spawn period
		"VELOCITY":-200, # Pixels per second
		"SPRITE":preload("res://Sprites/shmup/ennemi 2.png"),
		"SCALE":0.2,
		"COLLISION":64,#Radius
		"SCORE":10,
		"LIFE":5,
		"DAMAGE":5, # on player collision
		"FIRERATE":1.9, # in seconds
		"PROJECTILE":"ENEMY",
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
			"COLLISION":8, #Radius
			"TYPE":"FRONT"
		},
		"ENEMY":{
			"FRIEND":false,
			"VELOCITY":500,
			"SPRITE":preload("res://Sprites/shmup/bullet ennemi.png"),
			"SCALE":0.2,
			"LIFE":1,
			"DAMAGE":1,
			"COLLISION":8,#Radius
			"TYPE":"TARGET"
		}
	}
}

func _ready() -> void:
	player.life=DATA.PLAYER.LIFE
	if invincible:
		player.collision_mask=16
	Engine.time_scale=gameSpeed
	startPosition=player.global_position
	GlobalSettings.settings_changed.connect(settingsRefresh)
	#await get_tree().create_timer(20.0).timeout
	#get_parent().next_game()
	#Engine.time_scale=1
	#pass#set_deferred("startPositin",player.global_position)

var spawnTimer=DATA.ENEMY.PERIOD
var spawnBigTimer=DATA.ENEMYBIG.PERIOD
var playerDead=false

#var invincibilityPressed:bool=false

var gameSpeeds=[0.25,0.5,0.75,1]
var gameSpeedIndex=3
var gameSpeedPressed:bool=false

var autoFirePressed:bool=false

var highContrastPressed:bool=false

@export var playerProjectileSpeed:float=1
@export var enemyProjectileSpeed:float=1

var playerProjectileSpeedPressed:bool=false
var enemyProjectileSpeedPressed:bool=false

const PLAYER_PROJECTILE_SPEED_ALTERNATE:float=1.5
const ENEMY_PROJECTILE_SPEED_ALTERNATE:float=0.66

var gameTime=30

func _process(delta: float) -> void:
	gameTime-=delta/gameSpeeds[gameSpeedIndex]
	print("gameTime "+str(gameTime))
	if gameTime<=0:
		get_parent().next_game()
	#################################
	#if Input.get_action_raw_strength("Shmup_Invincibility"):
	#	if not invincibilityPressed:
	#		invincibilityPressed=true
	#		invincibleSet(not invincible)
	#else:
	#	invincibilityPressed=false
	#################################
	if Input.get_action_raw_strength("Shmup_game_speed"):
		if not gameSpeedPressed:
			gameSpeedPressed=true
			gameSpeedIndex+=1
			if gameSpeedIndex>=gameSpeeds.size():
				gameSpeedIndex=0
			Engine.time_scale=gameSpeeds[gameSpeedIndex]
	else:
		gameSpeedPressed=false
	#################################
	#if Input.get_action_raw_strength("Shmup_autofire"):
		#if not autoFirePressed:
			#autoFirePressed=true
			#player.autoFire=not player.autoFire
	#else:
		#autoFirePressed=false
	#################################
	if Input.get_action_raw_strength("Shmup_high_contrast"):
		if not highContrastPressed:
			highContrastPressed=true
			if $Parallax/Background.modulate==Color.WHITE:
				$Parallax/Background.modulate=Color.DIM_GRAY
			else:
				$Parallax/Background.modulate=Color.WHITE
	else:
		highContrastPressed=false
	#################################
	if Input.get_action_raw_strength("Shmup_player_projectile_speed"):
		if not playerProjectileSpeedPressed:
			playerProjectileSpeedPressed=true
			if playerProjectileSpeed==1:
				playerProjectileSpeed=PLAYER_PROJECTILE_SPEED_ALTERNATE
				for e in get_children():
					if e.name.contains("Bullet") and e.friend:
						e.velocity*=PLAYER_PROJECTILE_SPEED_ALTERNATE
			else:
				playerProjectileSpeed=1
				for e in get_children():
					if e.name.contains("Bullet") and e.friend:
						e.velocity/=PLAYER_PROJECTILE_SPEED_ALTERNATE
	else:
		playerProjectileSpeedPressed=false
	if Input.get_action_raw_strength("Shmup_enemy_projectile_speed"):
		if not enemyProjectileSpeedPressed:
			enemyProjectileSpeedPressed=true
			if enemyProjectileSpeed==1:
				enemyProjectileSpeed=ENEMY_PROJECTILE_SPEED_ALTERNATE
				for e in get_children():
					if e.name.contains("Bullet") and not e.friend:
						e.velocity*=ENEMY_PROJECTILE_SPEED_ALTERNATE
			else:
				enemyProjectileSpeed=1
				for e in get_children():
					if e.name.contains("Bullet") and not e.friend:
						e.velocity/=ENEMY_PROJECTILE_SPEED_ALTERNATE
	else:
		enemyProjectileSpeedPressed=false
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
			spawn(DATA.ENEMY,Vector2(1400,randf_range(60,660)))
			spawnTimer+=DATA.ENEMY.PERIOD
		while spawnBigTimer<=0:
			spawn(DATA.ENEMYBIG,Vector2(1400,randf_range(60,660)))
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
	
func settingsRefresh()->void:
	invincibleSet(GlobalSettings.invincibility)

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
