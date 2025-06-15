extends Node2D

var cooldown_time := 3.0
var cooldown_timer := 0.0
var max_angle := TAU  # voller Kreis = 2*PI

func _process(delta):
	cooldown_timer += delta
	if cooldown_timer > cooldown_time:
		cooldown_timer = 0.0
	_draw()  # ruft _draw() auf

func _draw():
	var progress := cooldown_timer / cooldown_time  # 0 bis 1
	var angle := progress * max_angle
	var mouse_pos := get_viewport().get_mouse_position()
	var radius := 40
	var color := Color(1, 1, 0)  # gelb
	var line_width := 4

	draw_arc(mouse_pos, radius, 0, angle, 64, color, line_width)
