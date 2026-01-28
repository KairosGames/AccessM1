extends RigidBody2D
class_name Bullet
var model
var friend:bool
var life:int
var damage:int

const LIFESPAN:float=4 # in seconds

func _ready() -> void:
	name="Bullet"

var lifeSpan:float=LIFESPAN

func setModel(model,where)->void:
	apply_impulse(Vector2(model.VELOCITY,0))
	global_position=where
	if model.has("OFFSET"):
		global_position+=model.OFFSET
	$Sprite.texture=model.SPRITE
	$Sprite.scale=Vector2(model.SCALE,model.SCALE)
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
	lifeSpan-=delta
	if delta<=0:
		queue_free()
