extends AudioStreamPlayer

var default_volume_db: float

func _ready() -> void:
	# Remember whatever volume you set in the editor
	default_volume_db = volume_db


func play_speech(default_volume_db) -> void:
	# Reset the volume before playing again
	volume_db = default_volume_db
	play()


func fade_out_and_stop(duration: float = 2.0) -> void:
	var tween := create_tween()
	tween.tween_property(self, "volume_db", -80.0, duration) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "stop"))
