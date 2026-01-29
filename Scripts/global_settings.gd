extends Node

var keybinds : Array

var shmup_timescale : float=1
var autofire : bool=false
var invincibility : bool=false
var playerProjectileSpeed : bool=false
var enemyProjectileSpeed : bool=false
var darkerBackground:bool=false

var auto_jump : bool
var coyote_time : float

var car_timescale : float = 1
var bebou_mode : bool
var one_button_mode : bool

signal settings_changed

func new_settings():
	settings_changed.emit()

func update_keybinds(event):
	for i in keybinds:
		i.bypass(event)
