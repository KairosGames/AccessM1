extends Node

var shmup_timescale : float
var autofire : bool
var invincibility : bool

var auto_jump : bool
var coyote_time : float

var car_timescale : float
var bebou_mode : bool
var one_button_mode : bool

signal settings_changed

func new_settings():
	settings_changed.emit()
