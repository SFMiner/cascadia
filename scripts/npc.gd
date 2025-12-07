extends Interactable

const interactable_type = "NPC"
@export var npc_name: String = "NPC"
@export var rect_size: Vector2 = Vector2(30,30)
@export var dialogue_id: String = "default"
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_node = $CollisionShape2D

func _ready() -> void:
	super._ready()  # IMPORTANT: Set up Area2D body detection from parent class
	interacted.connect(_on_interacted)
	var shape_resource = collision_shape_node.shape
	shape_resource = shape_resource.duplicate()
	collision_shape_node.shape = shape_resource
	shape_resource.size = rect_size
	play_idle()
	

func _on_interacted(_player: Node) -> void:
	# Trigger dialogue when the player interacts with this NPC.
	# The `_player` parameter is intentionally unused, and the underscore
	# suppresses the "unused parameter" warning.
	
	# Dynamically choose dialogue based on game state
	var chosen_dialogue = _get_dialogue_for_state()
	var dialogue_manager = get_tree().get_first_node_in_group("DialogueManager")
	dialogue_manager.position_panel(global_position + Vector2 (50,0))
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
