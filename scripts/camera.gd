extends Node3D

@export var sensitivity := Vector2(0.1, 0.1)
@export var touch_area_ratio := 0.5  # Правая часть экрана для управления камерой

var vertical_angle := 0.0
var viewport_size := Vector2()

func _ready():
	viewport_size = get_viewport().size

func _input(event):
	if event is InputEventScreenDrag:
		var touch_area = viewport_size.x * touch_area_ratio
		
		# Проверяем, что касание в правой части экрана
		if event.position.x > (viewport_size.x - touch_area):
			# Поворот персонажа по горизонтали
			var parent = get_parent()
			parent.rotation_degrees.y -= event.relative.x * sensitivity.x
			
			# Поворот камеры по вертикали
			vertical_angle -= event.relative.y * sensitivity.y
			vertical_angle = clamp(vertical_angle, -90.0, 90.0)
			rotation_degrees.x = vertical_angle
