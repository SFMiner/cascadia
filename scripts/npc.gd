extends Interactable

const interactable_type = "NPC"
@export var npc_name: String = "NPC"
@export var rect_size: Vector2 = Vector2(30,30)
@export var dialogue_id: String = "default"
@export var sprite_offset: float = 0.0

@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_node = $CollisionShape2D
@onready var speak_cooldown : Timer = $CoolDown
@onready var speak : AudioStreamPlayer = $Speak

var is_silent : bool = false
var default_volume 
	
var sb_green : StyleBoxFlat = load("res://scenes/green_panel.tres")

func _ready() -> void:
	super._ready()  # IMPORTANT: Set up Area2D body detection from parent class
	interacted.connect(_on_interacted)
	var shape_resource = collision_shape_node.shape
	shape_resource = shape_resource.duplicate()
	collision_shape_node.shape = shape_resource
	shape_resource.size = rect_size
	sprite.position.y += sprite_offset
	load_voice()
	play_idle()
	

func _on_interacted(_player: Node) -> void:
	
	# Trigger dialogue when the player interacts with this NPC.
	# The `_player` parameter is intentionally unused, and the underscore
	# suppresses the "unused parameter" warning.
	
	# Dynamically choose dialogue based on game state
	var chosen_dialogue = _get_dialogue_for_state()
	var dialogue_manager = get_tree().get_first_node_in_group("DialogueManager")
	dialogue_manager.position_panel(global_position + Vector2 (50,0))
	dialogue_manager.color_panel(sb_green)
	if is_silent:
		print("is_silent == true")
	else:
		print("is_silent == false")
		speak.play_speech(default_volume)
		if npc_name != "WillowSpirit":
			start_sound_timer(10)

	if dialogue_manager:
		dialogue_manager.start_dialogue(chosen_dialogue, self)
		


func _get_dialogue_for_state() -> String:
	# Check if wolves have been reintroduced
	var wolves_reintroduced = StoryState.get_flag("wolves_reintroduced")
	
	# Choose appropriate dialogue variant
	if wolves_reintroduced:
		# Check if this NPC has an "after wolves" variant
		var after_wolves_id = dialogue_id.replace("_intro", "_after_wolves")
		
		# Use the after_wolves variant if it exists, otherwise fall back to base
		var dialogue_manager = get_tree().get_first_node_in_group("DialogueManager")
		if dialogue_manager and dialogue_manager.dialogues.has(after_wolves_id):
			return after_wolves_id
	
	# Default to the base dialogue_id
	return dialogue_id

# Handler for player interactions; forwards to _on_interacted()
func on_player_interact(player: Node) -> void:
	_on_interacted(player)
	if npc_name != "WillowSpirit":
		if player.position.x < position.x:
			sprite.flip_h = true
		else: 
			sprite.flip_h = false
	play_lookup()

func play_idle():
	if npc_name == "Raven":
		ap.play("raven_idle")
	if npc_name == "Elk":
		ap.play("elk_idle")
	if npc_name == "WillowSpirit":
		ap.play("willow_idle")

func play_lookup():
	if npc_name == "Raven":
		ap.play("raven_lookup")
	if npc_name == "Elk":
		ap.play("elk_lookup")
	if npc_name == "WillowSpirit":
		ap.play("willow_lookup")


func _on_body_exited(body: Node) -> void:
	play_idle()
	if npc_name == "WillowSpirit":
		speak.fade_out_and_stop()
	
func start_sound_timer(cooldown_in_seconds : int):
	speak_cooldown.wait_time = cooldown_in_seconds
	is_silent = true
	speak_cooldown.start()


func load_voice():
	var voice : AudioStream
	if npc_name == "Raven":
		voice = load("res://assets/raven-solo.ogg")
	if npc_name == "Elk":
		voice = load("res://assets/elk-solo.ogg")
	if npc_name == "WillowSpirit":
		voice = load("res://assets/willow-solo.ogg")
	speak.stream = voice
	default_volume = speak.default_volume_db
		
func _on_cool_down_timeout() -> void:
	is_silent = false
