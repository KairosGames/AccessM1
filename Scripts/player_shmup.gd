extends CharacterBody2D
const SHMUP={
	"PLAYER":{
		"SPEED":100, # Pixels per second
		"FRICTION":10 # Pixels per second
	}
}
func _physics_process(delta: float)->void:
	velocity=lerp(velocity,Vector2.ZERO,delta*SHMUP.PLAYER.FRICTION)
	
	velocity+=Vector2(Input.get_action_strength("Right")*SHMUP.PLAYER.SPEED-Input.get_action_strength("Left")*SHMUP.PLAYER.SPEED,Input.get_action_strength("Down")*SHMUP.PLAYER.SPEED-Input.get_action_strength("Up")*SHMUP.PLAYER.SPEED)
	move_and_slide()
