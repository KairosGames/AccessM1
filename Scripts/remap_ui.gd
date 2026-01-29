extends Button
class_name Remap

var is_toggled : bool = false
var old_input

@export var action : String
@export var action_event_index : int = 0

func _ready() -> void:
	GlobalSettings.keybinds.append(self)
	toggle_mode = true
	#_on_toggled(false)
	old_input = text

func _on_toggled(toggled_on: bool) -> void:
	is_toggled = toggled_on
	print("toggled")
	if !action or !InputMap.has_action(action):
		print("no action")
		return
		
	if toggled_on == true:
		text = "Press any button"
		return
	
	if action_event_index >= InputMap.action_get_events(action).size():
		text = "Unassigned"
		return

func _unhandled_input(event: InputEvent) -> void:
	if is_toggled == true and event is InputEventKey:
		for i in InputMap.get_actions():
			var find_in = InputMap.action_get_events(i)
			for i2 : InputEvent in find_in:
				if InputMap.action_has_event(i, event):
					InputMap.action_erase_event(i, event)
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		text = event.as_text_key_label()
		button_pressed = false
		GlobalSettings.update_keybinds(event)
		release_focus()

func bypass(event : InputEvent):
	if text == event.as_text() and text == old_input:
		text = "Unassigned"
	old_input = text
