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

func setModel(model,where)->void:
	velocity=Vector2(model.VELOCITY,0)
	global_position=where
	if model.has("OFFSET"):
		global_position+=model.OFFSET
	$Sprite.texture=model.SPRITE
	$Sprite.scale=Vector2(model.SCALE,model.SCALE)
	$Collision.shape.radius=model.COLLISION
	friend=model.FRIEND
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
	
func _process(delta: float) -> void:
	position+=velocity*delta
	lifeSpan-=delta
	if delta<=0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if damage>=body.life:
		if body.name.contains("Enemy"):
			get_parent().scoreAdd(body.model.SCORE)
		body.queue_free()
	else:
		body.life-=damage
	life-=1
	if life<=0:
		queue_free()
