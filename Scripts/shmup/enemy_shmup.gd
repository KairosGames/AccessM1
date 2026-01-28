extends CharacterBody2D

class_name ShmupEnemy

@onready var game:Shmup=get_parent()
var bulletType
var model

func _ready() -> void:
	name="Enemy"

func _physics_process(delta: float)->void:
	move_and_slide()
	if get_last_slide_collision()!=null:
		var bonk=get_last_slide_collision().get_collider()
		if get_parent().invincible:
			if bonk.name.contains("Bullet"):
				get_parent().scoreAdd(model.SCORE)
				queue_free()
				bonk.queue_free()
		else:
			if bonk.name.contains("Player"):
				get_parent().playerDead=true
			else:
				bonk.queue_free()
			get_parent().scoreAdd(model.SCORE)
			queue_free()

func fire():
	var b=game.bulletModel.instantiate()
	b.call_deferred("setModel",bulletType,global_position)
	game.add_child(b)
	
func setModel(whatModel,where)->void:
	model=whatModel
	velocity=Vector2(model.VELOCITY,0)
	global_position=where
	$Sprite.texture=model.SPRITE
	$Sprite.scale=Vector2(model.SCALE,model.SCALE)
	collision_layer=8
	if get_parent().invincible:
		collision_mask=2
	else:
		collision_mask=1+2
	#print("Fired at"+str(global_position))
