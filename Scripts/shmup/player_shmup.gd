extends CharacterBody2D
class_name ShmupPlayer
@onready var game:Shmup=get_parent()
var life:int
var reload:float=0
var autoFire:bool=false
var shake:float=0

var baseScale:Vector2

func _ready() -> void:
	name="Player"
	baseScale=$Sprite.scale

func _process(delta: float) -> void:
	$Sprite.scale=lerp($Sprite.scale,baseScale,delta*10)
	$Sprite.position=lerp($Sprite.position,Vector2.ZERO,delta*10)+Vector2(randf_range(-shake,shake),randf_range(-shake,shake))
	get_parent().get_node("Camera").position=Vector2(randf_range(-shake,shake),randf_range(-shake,shake))*2
	shake=lerp(shake,0.0,delta*10)
	get_parent().modulate=Color(1+shake*0.02,1.0-shake*0.02,1.0-shake*0.02)

func _physics_process(delta: float)->void:
	velocity=lerp(velocity,Vector2.ZERO,delta*Shmup.DATA.PLAYER.FRICTION)
	if visible:
		velocity+=Vector2(Input.get_action_strength("Right")*Shmup.DATA.PLAYER.SPEED-Input.get_action_strength("Left")*Shmup.DATA.PLAYER.SPEED,Input.get_action_strength("Down")*Shmup.DATA.PLAYER.SPEED-Input.get_action_strength("Up")*Shmup.DATA.PLAYER.SPEED)
		move_and_slide()
		reload=max(reload-delta,0)
		if GlobalSettings.autofire or Input.get_action_strength("Action"):
			if reload<=0:
				reload+=game.DATA.PLAYER.RELOAD
				fire()

func fire():
	var b=game.bulletModel.instantiate()
	b.call_deferred("setModel",Shmup.DATA.BULLET.PLAYER,global_position)
	game.add_child(b)
	$ShootSound.play()
	$Sprite.scale*=Vector2(0.5,2)
	$Sprite.position+=Vector2(-32,0)
