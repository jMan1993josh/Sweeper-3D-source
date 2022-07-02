extends Spatial


onready var _anim_player = $AnimationPlayer
onready var _flag = $Flag
onready var _button_check_rays = $ButtonCheckRays.get_children()
onready var _col = $CollisionShape
onready var _press_sound = $PressSound
onready var _explode_sound = $ExplodeSound

var _isEmpty = false
var _isMine = false
var _isPressed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	_flag.visible = false


func set_up(empty, mine):
	_isEmpty = empty
	_isMine = mine


func set_flag():
	_flag.visible = !_flag.visible


func press_button():
	if _isPressed:
		return
	_isPressed = true
	_col.queue_free()
	_flag.visible = false
	_anim_player.play('press')
	
	if _isMine:
		_explode_sound.play()
	else:
		GlobalVars.buttons -= 1
	_press_sound.play()
	
	if _isEmpty:
		press_surrounding_buttons()


func press_surrounding_buttons():
	var delay = 0
	for ray in _button_check_rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			var r = ray.get_collider()
			if r.has_method('press_button') && !r._isMine && !r._isPressed:
				delay += 0.05
				yield(get_tree().create_timer(delay, false), "timeout")
				r.press_button()


func _on_AnimationPlayer_animation_finished(anim_name):
	yield(get_tree().create_timer(1, false), "timeout")
	queue_free()
