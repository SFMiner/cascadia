extends Control

@onready var panel: Panel  = $Panel
@onready var label: Label  = $Panel/Label
@onready var button: Button = $Panel/Button

var _queue: Array = []
var _current_speaker: Node = null

var dialogues := {
	"raven_intro": [
		"Raven: \nNo wolves in this valley anymore. The elk strut like they own the place.\n(click for more)",
		"Raven: \nWay upriver, where the sun sets, there's a gate to a wildlife preserve that has some wolves in it.\n(click for more)",
		"Raven: \nWatch what happens if you bring the wolves back… and then go talk to everyone."
	],
	"raven_after_wolves": [
		"Raven: \nYou brought them back! I can see the changes already.\n(click for more)",
		"Raven: \nThe elk are moving differently, staying alert. The willows will recover in time."
	],
	"elk_intro": [
		"Elk: \nEasy grazing these days. No predators, just grass and willows.\n(click for more)",
		"Elk: \nI can eat wherever I want. Nothing chases me anymore."
	],
	"elk_after_wolves": [
		"Elk: \nEver since the wolves showed up, I have to stay on the move.\n(click for more)",
		"Elk: \nI can't just stand by the river and chew all day anymore."
	],
	"willow_intro": [
		"Willow Spirit: \nMy roots are tired. The elk chew my shoots as soon as they rise.\n(click for more)",
		"Willow Spirit: \nWe used to have more cover, more songbirds, more life. Something is missing."
	],
	"willow_after_wolves": [
		"Willow Spirit: \nThe wolves are back. The elk don't linger here for hours now.\n(click for more)",
		"Willow Spirit: \nMy branches are slowly recovering. More birds will come soon."
	]
}

func _ready() -> void:
	add_to_group("DialogueManager")
	hide()
	button.pressed.connect(_on_next_pressed)

func position_panel(new_position : Vector2):
	print(panel.global_position)
	panel.global_position = new_position 
	print(panel.global_position)

func _input(event: InputEvent) -> void:
	# Advance dialogue on Enter key or mouse click when dialogue is visible
	if visible:
		if event.is_action_pressed("ui_accept") or event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_show_next()
			get_viewport().set_input_as_handled()

func start_dialogue(id: String, speaker: Node = null) -> void:
	_current_speaker = speaker
	_queue = dialogues.get(id, ["... (no dialogue found)"]).duplicate()
	_show_next()

func color_panel(new_stylebox : StyleBoxFlat):
	print("color_panel called with " + str(new_stylebox))
	#panel.styleBox.set("bg_color", new_color)
	panel.add_theme_stylebox_override("panel", new_stylebox)
	#add_theme_stylebox_override("panel", new_stylebox)

func show_system_message(text: String) -> void:
	_current_speaker = null
	_queue = [text]
	_show_next()

func _show_next() -> void:
	if _queue.is_empty():
		hide()
		return

	label.text = _queue.pop_front()
	show()

func _on_next_pressed() -> void:
	_show_next()


func _on_label_resized() -> void:
	panel.size = label.size + (Vector2(15,15)) # Replace
