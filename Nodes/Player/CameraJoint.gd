extends SpringArm

export var x_clamp := Vector2(-90.0, 90.0) # Min, Max

onready var _distance := spring_length
onready var _cam := $Camera

func _ready() -> void:
	set_as_toplevel(true)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= deg2rad(event.relative.y * GlobalVars.mouse_sensitivity)
		rotation_degrees.x = clamp(rotation_degrees.x, x_clamp.x, x_clamp.y)
		rotation_degrees.y -= deg2rad(event.relative.x * GlobalVars.mouse_sensitivity)
