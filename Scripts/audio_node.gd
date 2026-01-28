extends AudioStreamPlayer2D

var called : bool = false

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if self.playing == true and called == false:
		called = true
		print(self.get_playback_position())
		on_playing()

func on_playing():
	var sound_name = stream.resource_path.get_file().get_basename()
	print(sound_name)
	GlobalCc.write(sound_name, self.get_playback_position())
	await get_tree().create_timer(self.stream.get_length()).timeout
	called = false
