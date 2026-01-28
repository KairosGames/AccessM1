extends CharacterBody2D

class_name ShmupEnemy

@onready var game:Shmup=get_parent()
var bulletType
var model
var life:int
var damage:int

func _ready() -> void:
	name="Enemy"

func _physics_process(delta: float)->void:
	move_and_slide()
	if get_last_slide_collision()!=null:
		var bonk=get_last_slide_collision().get_collider()
		if bonk.name.contains("Bullet"):
			if bonk.damage>=life:
				get_parent().scoreAdd(model.SCORE)
				queue_free()
			else:
				life-=bonk.damage
			bonk.life-=1
			if bonk.life<=0:
				bonk.queue_free()
		if not get_parent().invincible and bonk.name.contains("Player"):
			if damage>=bonk.life:
				get_parent().playerDead=true
			else:
				bonk.life-=damage
			get_parent().scoreAdd(model.SCORE)
			queue_free()

func fire():
	var b=game.bulletModel.instantiate()
	b.call_deferred("setModel",bulletType,global_position)
	game.add_child(b)

func setModel(whatModel,where)->void:
	model=whatModel
	damage=model.DAMAGE
	life=model.LIFE
	velocity=Vector2(model.VELOCITY,0)
	global_position=where
	$Collision.shape.radius=model.COLLISION
	$Sprite.texture=model.SPRITE
	$Sprite.scale=Vector2(model.SCALE,model.SCALE)
	collision_layer=8
	if get_parent().invincible:
		collision_mask=2
	else:
		collision_mask=1+2
	#print("Fired at"+str(global_position))
