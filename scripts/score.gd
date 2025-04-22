extends Label

func _ready():
	# Сохраняем ссылку на себя в Global, как ты и делал
	Global.score_label = self
	# Сразу обновляем текст, чтобы показать начальный счет "Score: 0"
	Global.update_score_label()
