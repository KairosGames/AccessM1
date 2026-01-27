extends RigidBody2D
class_name Bullet
var model

const LIFESPAN:float=4 # in seconds

var lifeSpan:float=LIFESPAN

func setModel(model,where)->void:
	apply_impulse(Vector2(model.VELOCITY,0))
	global_position=where
	if model.has("OFFSET"):
		global_position+=model.OFFSET
	$Sprite.texture=model.SPRITE
	$Sprite.scale=Vector2(model.SCALE,model.SCALE)
	if model.FRIEND:
		collision_layer=2
		collision_mask=4+8
	else:
		collision_layer=8
		collision_mask=1+2
	#print("Fired at"+str(global_position))
	
func _process(delta: float) -> void:
	lifeSpan-=delta
	if delta<=0:
		queue_free()
