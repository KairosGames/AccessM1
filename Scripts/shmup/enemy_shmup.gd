extends CharacterBody2D

class_name ShmupEnemy

@onready var game:Shmup=get_parent()
var model
var life:int
var damage:int
var reload:float=0

func _ready() -> void:
	name="Enemy"

func _physics_process(delta: float)->void:
	move_and_slide()
	if global_position.x<-200:
		queue_free()
	else:
		if get_last_slide_collision()!=null:
			var bonk=get_last_slide_collision().get_collider()
			if not get_parent().invincible and bonk.name.contains("Player"):
				if damage>=bonk.life:
					get_parent().playerDead=true
				else:
					bonk.life-=damage
				get_parent().scoreAdd(model.SCORE)
				queue_free()

func _process(delta: float) -> void:
	if model.has("PROJECTILE"):
		reload-=delta
		while reload<=0:
			reload+=model.FIRERATE
			fire()

func fire()->Bullet:
	var b=game.bulletModel.instantiate()
	b.call_deferred("setModel",get_parent().DATA.BULLET[model.PROJECTILE],global_position)
	game.add_child(b)
	return b

func setModel(whatModel,where)->void:
	model=whatModel
	damage=model.DAMAGE
	life=model.LIFE
	velocity=Vector2(model.VELOCITY,0)
	global_position=where
	$Collision.shape.radius=model.COLLISION
	$Sprite.texture=model.SPRITE[GlobalSettings.other_color]
	$Sprite.scale=Vector2(model.SCALE,model.SCALE)
	collision_layer=8
	if get_parent().invincible:
		collision_mask=2
	else:
		collision_mask=1+2
