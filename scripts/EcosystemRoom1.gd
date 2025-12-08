extends Node2D

@onready var splash : Sprite2D = $Splash
@onready var title : Sprite2D = $Splash/Title
@onready var ap : AnimationPlayer = $AnimationPlayer
@onready var wolves : Node2D = $Environment/Wolves
@onready var instructions : Label = $Splash/Title/Instructions

func _ready() -> void:
	splash.visible = true
	title.modulate = Color(1,1,1,0)
	wolves.visible = false
	add_to_group("Main")
	if StoryState.get_var("wolf_pop") == null:
		StoryState.set_var("wolf_pop", 0)
		StoryState.set_var("elk_pop", 12)
		StoryState.set_var("willow_health", 3)

	for character in $Characters.get_children():
		character.z_index = character.position.y
	
	ap.play("fade_in")
