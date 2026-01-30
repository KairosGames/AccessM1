extends CanvasLayer

#region declarations
@onready var bg_1_general = $Control/Bg1_General
@onready var audio_box_container = $Control/Audio/HBoxContainer
@onready var controlsbox_container = $Control/Controls/VBoxContainer
@onready var acces_container = $Control/Accessibility/TabContainer

#@onready var platformer_container = $Control/Accessibility/AccesContainer/Platformer/PlatformerContainer
#@onready var racing_container = $"Control/Accessibility/AccesContainer/Racing Game/RacingContainer"
#@onready var shmup_container = $Control/Accessibility/AccesContainer/Shmup/ShmupContainer

@onready var audio_button = $Control/ButtonLeftContainer/Audio
@onready var general_button = $Control/ButtonLeftContainer/General_button
@onready var controls = $Control/ButtonLeftContainer/Controls
@onready var accessibility = $Control/ButtonLeftContainer/Accessibility
#@onready var racing_game = $"Control/Accessibility/AccesContainer/Racing Game"
#@onready var platformer = $Control/Accessibility/AccesContainer/Platformer
#@onready var shmup = $Control/Accessibility/AccesContainer/Shmup

signal On_Current_Button_Changed()
var current_pressed_button:
	set(value):
			if current_pressed_button != value:
				# Update the variable first so DisableContainers knows the 'target'
				current_pressed_button = value 
				# Now fire the signal to clean up old containers
				On_Current_Button_Changed.emit()
				# Finally, show the new one
				ShowPopup()
var actualPopup
#endregion

func _ready():
	On_Current_Button_Changed.connect(DisableContainers)

func ShowPopup():
	if current_pressed_button == null:
		return

	match current_pressed_button:
		audio_button:
			SetPopupVisible(audio_box_container, true)
		controls:
			SetPopupVisible(controlsbox_container,true)
		accessibility:
			controlsbox_container.visible = false
			SetPopupVisible(acces_container, true)
		#racing_game, platformer, shmup:
			# Ensure the parent is visible first!
			acces_container.visible = true 
			
			# Then show the specific sub-container
			#if current_pressed_button == racing_game:
				#SetPopupVisible(racing_container, true)
			#elif current_pressed_button == platformer:
				#SetPopupVisible(platformer_container, true)
			#elif current_pressed_button == shmup:
				#SetPopupVisible(shmup_container, true)
		

func DisableContainers():
	if actualPopup == null:
		return

	#var sub_containers = [racing_container, platformer_container, shmup_container]
	
	# 2. Identify if we are moving to a "Main" menu (Audio, General, etc.)
	var main_buttons = [audio_button, general_button, controls]
	
	if current_pressed_button in main_buttons:
		# If switching to a main menu, we hide the current popup normally
		# (This will hide AccesContainer if it was the actualPopup)
		actualPopup.visible = false
	#else:
		# 3. If we are staying within the Accessibility branch, 
		# only hide the sub-containers, NEVER the acces_container itself.
		#for container in sub_containers:
			#if container != null:
				#container.visible = false

func SetBgColor(newcolor : Color):
	if(bg_1_general.color != newcolor):
		bg_1_general.color = newcolor

func SetPopupVisible(Pop, isVisible : bool):
	if Pop == null:
		print("Error: Tried to set visibility on a Nil node!")
		return
		
	Pop.visible = isVisible
	actualPopup = Pop
	

func _on_general_pressed():
	current_pressed_button =  general_button
	SetBgColor(Color.RED)



func _on_audio_pressed():
	current_pressed_button = audio_button
	SetBgColor(Color.AQUA)



func _on_controls_pressed():
	current_pressed_button =  controls
	SetBgColor(Color.AQUAMARINE)
	

func _on_accessibility_pressed():
	current_pressed_button =  accessibility
	SetBgColor(Color.BROWN)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		if self.visible == false:
			self.show()
			Engine.time_scale = 0
		else:
			self.hide()
			Engine.time_scale = 1
			GlobalSettings.new_settings()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_quit_menu_pressed() -> void:
	self.hide()
	Engine.time_scale = 1
	GlobalSettings.new_settings()

#func _on_racing_game_pressed():
	#current_pressed_button =  racing_game



#func _on_platformer_pressed():
	#current_pressed_button =  platformer



#func _on_shmup_pressed():
	#current_pressed_button = shmup
