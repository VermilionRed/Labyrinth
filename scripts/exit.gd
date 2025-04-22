extends Button

func _pressed():
	print("Exit button pressed. Quitting game.") # Сообщение для отладки
	get_tree().quit()
