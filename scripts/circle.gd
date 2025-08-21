extends Node2D


func _draw():
	var rect = Rect2(Vector2.ZERO, Vector2(4, 4))
	draw_rect(rect, Color(1, 0, 0, 0.5), true) # true = preenchido
