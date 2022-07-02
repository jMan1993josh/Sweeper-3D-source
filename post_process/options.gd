extends Node

export(Material) var post_process_lcd
export(Material) var post_process_blur
export(Material) var post_process_dither_band

func _ready():
	set_fov(Engine.get_target_fps())

func set_fov(value: int):
	Engine.set_target_fps(value)

func set_post_process(enabled: bool):
	post_process_lcd.set_shader_param("enabled", enabled)
	post_process_blur.set_shader_param("enabled", enabled)
	
func set_lcd_opacity(value: float):
	post_process_lcd.set_shader_param("lcd_opacity",value)
	
func set_lcd_scanline_gap(value: int):
	post_process_lcd.set_shader_param("scanline_gap",value)

func set_color_depth(value: int):
	post_process_dither_band.set_shader_param("col_depth", value)

func set_dither_banding(enabled: bool):
	post_process_dither_band.set_shader_param("dither_banding", enabled)

func set_mouse_sensitivity(value: float):
	GlobalVars.mouse_sensitivity = value
