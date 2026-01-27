extends CharacterBody2D

class_name ShmupEnemy

@onready var game:Shmup=get_parent()
var bulletType

var firing:bool=false
func _physics_process(delta: float)->void:
	#velocity=lerp(velocity,Vector2.ZERO,delta*Shmup.DATA.PLAYER.FRICTION)
	
	#velocity+=Vector2(Input.get_action_strength("Right")*Shmup.DATA.PLAYER.SPEED-Input.get_action_strength("Left")*Shmup.DATA.PLAYER.SPEED,Input.get_action_strength("Down")*Shmup.DATA.PLAYER.SPEED-Input.get_action_strength("Up")*Shmup.DATA.PLAYER.SPEED)
	move_and_slide()
	if get_last_slide_collision()!=null:
		queue_free()
		get_last_slide_collision().get_collider().queue_free()

func fire():
	var b=game.bulletModel.instantiate()
	b.call_deferred("setModel",bulletType,global_position)
	game.add_child(b)
	
func setModel(model,where)->void:
	velocity=Vector2(model.VELOCITY,0)
	global_position=where
	$Sprite.texture=model.SPRITE
	$Sprite.scale=Vector2(model.SCALE,model.SCALE)
	collision_layer=8
	collision_mask=1+2
	#print("Fired at"+str(global_position))
