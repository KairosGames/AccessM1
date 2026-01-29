extends CanvasLayer

#region declarations
@onready var bg_1_general = $Control/Bg1_General
@onready var audio_box_container = $Control/Audio/AudioBoxContainer
@onready var controlsbox_container = $Control/Controls/ControlsboxContainer

@onready var audio_button = $Control/ButtonLeftContainer/Audio
@onready var general_button = $Control/ButtonLeftContainer/General_button
@onready var controls = $Control/ButtonLeftContainer/Controls
@onready var accessibility = $Control/ButtonLeftContainer/Accessibility
var current_pressed_button;
#endregion

func CheckLastPressedbutton():
	if(current_pressed_button != null):
		if(current_pressed_button != audio_button):
			SetPopupVisible(audio_box_container, false)
		else:
			SetPopupVisible(audio_box_container, true)
		if (current_pressed_button != accessibility):
			SetPopupVisible(controlsbox_container, false)
		else :
			SetPopupVisible(controlsbox_container, true)
		print(current_pressed_button.name)


func SetBgColor(newcolor : Color):
	if(bg_1_general.color != newcolor):
		bg_1_general.color = newcolor

func SetPopupVisible(Pop, isVisible : bool):
		Pop.visible = isVisible
	
	
	

func _on_general_pressed():
	current_pressed_button =  general_button
	SetBgColor(Color.RED)
	# normalement je ferais un signal pour  faire en sorte 
	#que quand la valeur du dernier bouton pressed est différent de nul
	#je check lequel. Mais la flemme
	CheckLastPressedbutton()


func _on_audio_pressed():
	current_pressed_button = audio_button
	SetBgColor(Color.AQUA)
	CheckLastPressedbutton()


func _on_controls_pressed():
	current_pressed_button =  controls
	SetBgColor(Color.AQUAMARINE)
	CheckLastPressedbutton()

func _on_accessibility_pressed():
	current_pressed_button =  accessibility
	SetBgColor(Color.BROWN)
	CheckLastPressedbutton()
