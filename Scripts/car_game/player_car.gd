extends Node2D

var is_one_button : bool = true
var double_tap : float = 0.25
var direction : bool = true
var waiting_tap : bool = false

@onready var timer : Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_one_button == true:
		$Sprite2D2.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if direction == true:
		$Sprite2D2.rotation = 0
	else:
		$Sprite2D2.rotation = deg_to_rad(180)
	
	if is_one_button == false:
		if Input.is_action_pressed("Up"):
			self.position.y += -350 * delta
		if Input.is_action_pressed("Down"):
			self.position.y += 350 * delta

	elif is_one_button == true:

		if Input.is_action_just_pressed("Up"):
			if waiting_tap == true:
				waiting_tap = false
				if direction == true:
					direction = false
				else:
					direction = true
			tap_timer()

		
		if Input.is_action_pressed("Up"):
			if direction == true:
				self.position.y += -350 * delta
			else:
				self.position.y += 350 * delta

	position.y = clamp(position.y, 128, 592)

func tap_timer():
	waiting_tap = true
	timer.wait_time = double_tap
	timer.start()


func _on_timer_timeout() -> void:
	waiting_tap = false
