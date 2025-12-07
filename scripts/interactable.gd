extends Area2D
class_name Interactable

signal interacted(player)

@export var prompt_text: String = "Press [E]"

var _player_in_range: Node = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	print (body.name + " has entered " + name)
	if body.is_in_group("player") or body.name == "Player":
		_player_in_range = body
		on_player_interact(body)

func _on_body_exited(body: Node) -> void:
	print (body.name + " has exited " + name)
	if body == _player_in_range:
		_player_in_range = null

func _input(event: InputEvent) -> void:
	if _player_in_range and event.is_action_pressed("ui_accept"):
		on_player_interact(_player_in_range)

func on_player_interact(player: Node) -> void:
	emit_signal("interacted", player)
