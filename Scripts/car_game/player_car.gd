extends Node2D

var is_one_button : bool = false

#@onready var game_manager : Game_Manager = self.get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if is_one_button == false:
		if Input.is_action_pressed("Up"):
			self.position.y += -10
		if Input.is_action_pressed("Down"):
			self.position.y += 10
	
	position.y = clamp(position.y, 128, 592)
