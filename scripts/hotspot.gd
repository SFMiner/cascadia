extends Interactable

@export var hotspot_id: String = "hotspot"
@export var science_action: String = "none"

func _ready() -> void:
	super._ready()  # IMPORTANT: Set up Area2D body detection from parent class
	interacted.connect(_on_interacted)

func _on_interacted(_player: Node) -> void:
	# Handle interaction with this hotspot. The `_player` parameter is unused
	# but kept to match the signal signature; prefixing with an underscore
	# suppresses the unused parameter warning.
	match science_action:
		"reintroduce_wolves":
			_reintroduce_wolves()
		"observe_changes":
			_observe_changes()
		_:
			_default_action()

func _reintroduce_wolves() -> void:
	var wolves = StoryState.get_var("wolf_pop", 0)
	var main = get_tree().get_first_node_in_group("Main")
	print(main.name)
	main.get_node_or_null("Environment").get_node_or_null("Wolves").visible = true
	if wolves > 0:
		_show_feedback("The wolves are already here. Adding more right now might unbalance things.")
		return

	StoryState.set_var("wolf_pop", 4)
	var elk = StoryState.get_var("elk_pop", 12)
	elk -= 3
	StoryState.set_var("elk_pop", elk)

	var willow = StoryState.get_var("willow_health", 3)
	willow += 1
	if willow > 5:
		willow = 5
	StoryState.set_var("willow_health", willow)

	StoryState.set_flag("wolves_reintroduced", true)
	_show_feedback("You reintroduce a small wolf pack. The elk start acting more cautious...")

func _observe_changes() -> void:
	var wolves = StoryState.get_var("wolf_pop", 0)
	var elk = StoryState.get_var("elk_pop", 12)
	var willow = StoryState.get_var("willow_health", 3)

	var text := "Current observations:\n"
	text += "- Wolves: %d\n" % wolves
	text += "- Elk: %d\n" % elk
	text += "- Willow health (0–5): %d" % willow

	_show_feedback(text)

func _default_action() -> void:
	_show_feedback("You interact with %s." % hotspot_id)

func _show_feedback(text: String) -> void:
	var dialogue_manager = get_tree().get_first_node_in_group("DialogueManager")
	if dialogue_manager:
		dialogue_manager.show_system_message(text)

# Handler for player interactions; forwards to _on_interacted()
func on_player_interact(player: Node) -> void:
	_on_interacted(player)
