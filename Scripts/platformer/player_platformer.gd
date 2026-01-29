class_name PlayerPlatformer extends CharacterBody2D

@export_category("Player Movement")
@export var max_speed: float = 500.0
@export var acceleration: float = 1000.0
@export var braking_strength: float = 3000.0
@export var jump_strength: float = 1200.0

@export_category("Gravity")
@export var max_fall_speed: float = 2000.0
@export var gravity: float = 4000.0

@export_category("Gameplay")
@export var reset_pos: Marker2D
@export var gate: Area2D
@export var health: int = 100
@export var strength_attack: int = 10

var move_dir: Vector2 = Vector2.ZERO
var win_timer: float = 0.0

var can_jump: bool = true
var coyote_time: float = 0.0
var can_use_jump: bool = true
var has_control: bool = true
var landing_played: bool = true
var move_sound_playing: bool = true
var play_victory_sound: bool = false

func _ready() -> void:
	position = reset_pos.position
	GlobalSettings.settings_changed.connect(settings)

func _process(delta: float) -> void:
	get_input()
	check_pos()
	check_win(delta)

func _physics_process(delta: float) -> void:
	move_player(delta)

func set_player_stats(p_health: int, p_attack: int):
	health = p_health
	strength_attack = p_attack

func get_input():
	if not has_control : return
	move_dir = Input.get_vector("Left", "Right", "Up", "Down")
	if move_dir.length() < 0.2:
		move_dir = Vector2.ZERO
	if Input.is_action_just_pressed("Action") && can_use_jump:
		jump()

func move_player(delta: float):
	handle_acceleration(delta)
	handle_gravity(delta)
	move_and_slide()

func handle_acceleration(delta: float):
	var dir: float = 1.0 if velocity.x >= 0.0 else -1.0
	if move_dir.length() != 0:
		velocity.x += move_dir.x * acceleration * delta
		if move_sound_playing == true:
			move_sound_playing = false
			$"../Sound/MovingSound".play()
		if (velocity.x * Vector2.RIGHT).normalized().x != (move_dir.x * Vector2.RIGHT).normalized().x:
			velocity.x -= braking_strength * dir * delta
		if velocity.x * dir > max_speed:
			velocity.x = max_speed * dir
		return
	else:
		move_sound_playing = true
		$"../Sound/MovingSound".stop()
	
	velocity.x -= braking_strength * dir * delta
	if velocity.x * dir < 0.0:
		velocity.x = 0.0

func handle_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta
		landing_played = false
		$"../Sound/MovingSound".stop()
		move_sound_playing = false
		if velocity.y < -max_fall_speed:
			velocity.y = -max_fall_speed
		if can_jump:
			await get_tree().create_timer(coyote_time).timeout
			if not is_on_floor():
				can_jump = false
	check_floor.call_deferred()

func check_floor():
	if is_on_floor():
		can_jump = true
		if landing_played == false:
			$"../Sound/LandSound".play()
			landing_played = true
			move_sound_playing = true

func jump() -> void:
	if can_jump:
		velocity.y = -jump_strength
		can_jump = false
		$"../Sound/JumpSound".play()

func check_pos() -> void:
	position.x = clamp(position.x, 0.0, 1280.0)
	if position.y > 1000.0:
		position = reset_pos.position
		$"../Sound/DeathSound".play()

func check_win(delta: float) -> void:
	if gate.has_overlapping_bodies():
		win_timer += delta
		if play_victory_sound == true:
			play_victory_sound = false
			$"../Sound/DoorSound".play()
			$"../Sound/EndSound".play()
		if (win_timer > 0.75):
			(get_parent().get_parent() as GameManager).next_game()
	else:
		win_timer = 0.0
		play_victory_sound = true

func launch_auto_jump():
	if can_use_jump: return
	jump()

func settings():
	coyote_time = GlobalSettings.coyote_time
	can_use_jump = GlobalSettings.auto_jump
