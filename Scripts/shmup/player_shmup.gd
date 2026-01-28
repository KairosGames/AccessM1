extends CharacterBody2D
class_name ShmupPlayer
@onready var game:Shmup=get_parent()
var firing:bool=false
var life:int

func _ready() -> void:
	name="Player"

func _physics_process(delta: float)->void:
	velocity=lerp(velocity,Vector2.ZERO,delta*Shmup.DATA.PLAYER.FRICTION)
	if visible:
		velocity+=Vector2(Input.get_action_strength("Right")*Shmup.DATA.PLAYER.SPEED-Input.get_action_strength("Left")*Shmup.DATA.PLAYER.SPEED,Input.get_action_strength("Down")*Shmup.DATA.PLAYER.SPEED-Input.get_action_strength("Up")*Shmup.DATA.PLAYER.SPEED)
	move_and_slide()
	if Input.get_action_strength("Action"):
		if not firing:
			firing=true
			fire()
	else:
			firing=false

func fire():
	var b=game.bulletModel.instantiate()
	b.call_deferred("setModel",Shmup.DATA.BULLET.PLAYER,global_position)
	game.add_child(b)
