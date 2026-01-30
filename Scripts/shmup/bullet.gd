extends Area2D

class_name Bullet
var model
var friend:bool
var life:int
var damage:int
var velocity:Vector2=Vector2.ZERO

const LIFESPAN:float=4 # in seconds

func _ready() -> void:
	name="Bullet"

var lifeSpan:float=LIFESPAN

func setModel(what,where)->void:
	model=what
	velocity=Vector2(model.VELOCITY,0)
	global_position=where
	if model.has("OFFSET"):
		global_position+=model.OFFSET
	$Sprite.scale=Vector2(model.SCALE,model.SCALE)*4
	modulate=Color(2,2,2,1)
	$Collision.shape.radius=model.COLLISION
	friend=model.FRIEND
	if friend:
		$Sprite.texture=model.SPRITE[GlobalSettings.player_color]
	else:
		$Sprite.texture=model.SPRITE[GlobalSettings.other_color]
	life=model.LIFE
	damage=model.DAMAGE
	if friend:
		collision_layer=2
		collision_mask=4+8
	else:
		collision_layer=8
		if get_parent().invincible:
			collision_mask=2
		else:
			collision_mask=1+2
	if model.has("TYPE"):
		match model.TYPE:
			"FRONT":
				if not friend:
					velocity=-velocity
			"TARGET":
				var angle=global_position.angle_to_point(get_parent().player.global_position)
				$Sprite.rotation_degrees=rad_to_deg(angle+PI)
				velocity=velocity.rotated(angle)
	if friend:
		velocity*=get_parent().playerProjectileSpeed
	else:
		velocity*=get_parent().enemyProjectileSpeed

func _process(delta: float) -> void:
	position+=velocity*delta
	lifeSpan-=delta
	if delta<=0:
		queue_free()
	$Sprite.scale=lerp($Sprite.scale,Vector2(model.SCALE,model.SCALE),delta*20)
	modulate=lerp(modulate,Color.WHITE,delta)

func _on_body_entered(body: Node2D) -> void:
	if damage>=body.life:
		if body.name.contains("Enemy"):
			get_parent().scoreAdd(body.model.SCORE)
		body.queue_free()
	else:
		body.life-=damage
		body.shake+=damage*5
	$PlayerHurtSound.play() #A FIX
	life-=1
	if life<=0:
		queue_free()
