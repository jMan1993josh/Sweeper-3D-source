extends KinematicBody

export var speed := 7.0
export var run_speed := 14.0
export var rotation_speed := 20.0
export var jump_strength := 20.0
export var jump_enabled := true
export var gravity := 50.0
export var acceleration := 20.0
export var can_move := true

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN
var _jump_buffer := false
var _cur_pos := Vector3.ZERO

onready var _spring_arm: SpringArm = $SpringArm
onready var _model = $MeshInstance
onready var _button_finder := $ButtonFinder
onready var _flag_ray = $SpringArm/Camera/FlagRay
onready var _anim_player = $AnimationPlayer


func reset_pos():
	translation = _cur_pos


func _physics_process(delta) -> void:
	if can_move:
		var move_direction := Vector3.ZERO
		move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		move_direction.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
		move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
		
		var move_speed = run_speed if Input.is_action_pressed("run") else speed
		
		#if !is_on_wall():
		_velocity.x = move_direction.x * move_speed
		_velocity.z = move_direction.z * move_speed

		if !is_on_floor():
			_velocity.y -= gravity * delta
		
		if Input.is_action_just_pressed("jump") && !is_on_floor():
			_jump_buffer = true
		
		var just_landed := is_on_floor() && _snap_vector == Vector3.ZERO
		var is_jumping = (is_on_floor() && Input.is_action_just_pressed("jump")) || (Input.is_action_pressed("jump") && 
		is_on_floor() && _jump_buffer)
			
		if is_jumping:
			_jump_buffer = false
			_velocity.y = jump_strength
			_snap_vector = Vector3.ZERO
		elif just_landed:
			_snap_vector = Vector3.DOWN
			if _button_finder.is_colliding():
				var col = _button_finder.get_collider()
				if col.has_method('press_button'):
					col.press_button()
					if col._isMine:
						_anim_player.play("explode")
						
		
		_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
		
		if !Input.is_action_pressed("jump") && _velocity.y > 0 && !is_on_floor():
			_velocity.y = _velocity.y * 0.5
	


func _process(delta) -> void:
	_spring_arm.translation = translation
	if Input.is_action_just_pressed("set_flag"):
		if _flag_ray.is_colliding():
			var col = _flag_ray.get_collider()
			if col.has_method('set_flag'):
				col.set_flag()
	if GlobalVars.buttons <= 0 && GlobalVars.buttons != -1:
		_anim_player.play("Win")
		GlobalVars.buttons = -1


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'explode':
		yield(get_tree().create_timer(1.5, false), "timeout")
		GlobalVars.reset_stage()
