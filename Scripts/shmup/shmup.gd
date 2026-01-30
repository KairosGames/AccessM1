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
		"RELOAD":0.25, # To fire, in seconds
		"SPRITE":[preload("res://Sprites/shmup/player chara variants/chara_normal.png"),
				  preload("res://Sprites/shmup/player chara variants/chara_blanc.png"),
				  preload("res://Sprites/shmup/player chara variants/chara_bleu.png"),
				  preload("res://Sprites/shmup/player chara variants/chara_jaune.png"),
				  preload("res://Sprites/shmup/player chara variants/chara_noir.png"),
				  preload("res://Sprites/shmup/player chara variants/chara_rouge.png"),
				  preload("res://Sprites/shmup/player chara variants/chara_vert.png"),]
	},
	"ENEMY":{
		"PERIOD":1,# spawn period
		"VELOCITY":-1000, # Pixels per second
		"SPRITE":[preload("res://Sprites/shmup/ennemy chara variants/ennemi_normal.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_blanc.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_bleu.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_jaune.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_noir.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_rouge.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_vert.png"),],
		"SCALE":0.1,
		"COLLISION":32,#Radius
		"SCORE":10,
		"LIFE":1,
		"DAMAGE":2 # on player collision
	},
	"ENEMYBIG":{
		"PERIOD":6.19,# spawn period
		"VELOCITY":-200, # Pixels per second
		"SPRITE":[preload("res://Sprites/shmup/ennemy chara variants/ennemi_normal.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_blanc.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_bleu.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_jaune.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_noir.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_rouge.png"),
				  preload("res://Sprites/shmup/ennemy chara variants/ennemi_vert.png"),],
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
			"SPRITE":[preload("res://Sprites/shmup/player bullets variants/bullets_joueur_normal.png"),
					  preload("res://Sprites/shmup/player bullets variants/bullets_joueur_blanc.png"),
					  preload("res://Sprites/shmup/player bullets variants/bullets_joueur_bleu.png"),
					  preload("res://Sprites/shmup/player bullets variants/bullets_joueur_jaune.png"),
					  preload("res://Sprites/shmup/player bullets variants/bullets_joueur_noir.png"),
					  preload("res://Sprites/shmup/player bullets variants/bullets_joueur_rouge.png"),
					  preload("res://Sprites/shmup/player bullets variants/bullets_joueur_vert.png"),],
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
			"SPRITE":[preload("res://Sprites/shmup/ennemy bullets variants/bullets_ennemis_normal.png"),
					  preload("res://Sprites/shmup/ennemy bullets variants/bullets_ennemis_blanc.png"),
					  preload("res://Sprites/shmup/ennemy bullets variants/bullets_ennemis_bleu.png"),
					  preload("res://Sprites/shmup/ennemy bullets variants/bullets_ennemis_jaune.png"),
					  preload("res://Sprites/shmup/ennemy bullets variants/bullets_ennemis_noir.png"),
					  preload("res://Sprites/shmup/ennemy bullets variants/bullets_ennemis_rouge.png"),
					  preload("res://Sprites/shmup/ennemy bullets variants/bullets_ennemis_vert.png"),],
			"SCALE":0.2,
			"LIFE":1,
			"DAMAGE":1,
			"COLLISION":8,#Radius
			"TYPE":"TARGET"
		}
	}
}
#
#var colorMode:int=0 # from 0 to 6
#var otherColorMode:int=0 # from 0 to 6

func colorModeSet(what:int)->void:
	player.get_node("Sprite").texture=DATA.PLAYER.SPRITE[GlobalSettings.player_color]
	for e in get_children():
		if e.name.contains("Bullet") and e.friend:
			e.get_node("Sprite").texture=e.model.SPRITE[GlobalSettings.player_color]

#func colorModeSwitch()->void:
	#if colorMode>=6:
		#colorModeSet(0)
	#else:
		#colorModeSet(colorMode+1)

func enemyColorModeSet(what:int)->void:
	for e in get_children():
		if e.name.contains("Enemy") or (e.name.contains("Bullet") and not e.friend):
			e.get_node("Sprite").texture=e.model.SPRITE[GlobalSettings.other_color]

#func enemyColorModeSwitch()->void:
	#if otherColorMode>=6:
		#enemyColorModeSet(0)
	#else:
		#enemyColorModeSet(otherColorMode+1)

func _ready() -> void:
	player.life=DATA.PLAYER.LIFE
	if invincible:
		player.collision_mask=16
	startPosition=player.global_position
	GlobalSettings.settings_changed.connect(settingsRefresh)
	settingsRefresh()

var spawnTimer=DATA.ENEMY.PERIOD
var spawnBigTimer=DATA.ENEMYBIG.PERIOD
var playerDead=false

var gameSpeeds=[0.25,0.5,0.75,1]
var gameSpeedIndex=3
const GAME_SPEED_MIN=0.25
const GAME_SPEED_MAX=1
const GAME_SPEED_DEFAULT=1

var highContrastPressed:bool=false

@export var playerProjectileSpeed:float=1
@export var enemyProjectileSpeed:float=1

const PLAYER_PROJECTILE_SPEED_ALTERNATE:float=1.5
const ENEMY_PROJECTILE_SPEED_ALTERNATE:float=0.66

var gameTime:float=30
var end_sound_played: bool = true

func _process(delta: float) -> void:
	if Engine.time_scale>0:
		gameTime-=delta/Engine.time_scale
		if gameTime<=0:
			get_parent().next_game()
		if playerDead:
			if end_sound_played == true:
				end_sound_played = false
				$Sound/PlayerDeathSound.play()
				$Sound/LoseSound.play()
			if restart==RESTART_TIME:
				player.shake=100
				player.visible=false
				$Camera/EndPanel.visible=true
				for c in get_children():
					if c.name.contains("Enemy") or c.name.contains("Bullet"):
						c.queue_free()
			restart-=delta/Engine.time_scale
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
	$Sound/EnemyDeathSound.play()
	
func settingsRefresh()->void:
	invincibleSet(GlobalSettings.invincibility)
	if not get_parent().get_node("settings_ui").visible:
		Engine.time_scale=GlobalSettings.shmup_timescale
		#print(Engine.time_scale)
	##################################################################
	if GlobalSettings.playerProjectileSpeed:
		if playerProjectileSpeed==1:
			playerProjectileSpeed=PLAYER_PROJECTILE_SPEED_ALTERNATE
			for e in get_children():
				if e.name.contains("Bullet") and e.friend:
					e.velocity*=PLAYER_PROJECTILE_SPEED_ALTERNATE
	else:
		if playerProjectileSpeed==PLAYER_PROJECTILE_SPEED_ALTERNATE:
			playerProjectileSpeed=1
			for e in get_children():
				if e.name.contains("Bullet") and e.friend:
					e.velocity/=PLAYER_PROJECTILE_SPEED_ALTERNATE
	##################################################################
	if GlobalSettings.enemyProjectileSpeed:
		if enemyProjectileSpeed==1:
			enemyProjectileSpeed=ENEMY_PROJECTILE_SPEED_ALTERNATE
			for e in get_children():
				if e.name.contains("Bullet") and not e.friend:
					e.velocity*=ENEMY_PROJECTILE_SPEED_ALTERNATE
	else:
		if enemyProjectileSpeed==ENEMY_PROJECTILE_SPEED_ALTERNATE:
			enemyProjectileSpeed=1
			for e in get_children():
				if e.name.contains("Bullet") and not e.friend:
					e.velocity/=ENEMY_PROJECTILE_SPEED_ALTERNATE
	##################################################################
	if GlobalSettings.darkerBackground:
		if $Parallax/Background.modulate==Color.WHITE:
			$Parallax/Background.modulate=Color.DIM_GRAY
	else:
		if $Parallax/Background.modulate==Color.DIM_GRAY:
			$Parallax/Background.modulate=Color.WHITE
	##################################################################
	colorModeSet(GlobalSettings.player_color)
	enemyColorModeSet(GlobalSettings.other_color)

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
