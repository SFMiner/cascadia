extends AnimationPlayer

func fade_out_and_stop(duration: float = 2.0) -> void:
	# Create a new Tween for the fade effect
	var tween: Tween = create_tween()
	
	# Tween the "volume_db" property from its current value to a very low value (e.g., -80 dB, effectively silent)
	# The duration is set to the specified time (2.0 seconds in your case)
	tween.tween_property(self, "volume_db", -80.0, duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	
	# After the tween is complete, call the stop() method on the AudioStreamPlayer
	tween.tween_callback(self.stop)
