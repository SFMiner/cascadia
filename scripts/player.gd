extends CharacterBody2D

@export var speed: float = 200.0
@onready var ap : AnimationPlayer = $AnimationPlayer

var _facing_dir: Vector2 = Vector2.RIGHT
var anim : String = "walk_right"

func _ready() -> void:
	add_to_group("player")
	ap.play(anim)
	ap.stop()
	
func _physics_process(_delta: float) -> void:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if input_dir == Vector2.ZERO:
		ap.stop()
	elif abs(input_dir.x) > abs(input_dir.y):
		if input_dir.x > 0:
			anim = "walk_right"
		else:
			anim = "walk_left"
	else:
		if input_dir.y > 0:
			anim = "walk_down"
		else:
			anim = "walk_up"
	ap.play(anim)
	z_index = position.y
	
	scale = Vector2(1.5 * position.y / 627.0, 1.5 * position.y / 627.0)
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
		_facing_dir = input_dir

	velocity = input_dir * speed
	move_and_slide()
