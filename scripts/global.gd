extends Node

# Переменная для хранения текущего счета
var score := 0
# Ссылка на Label для отображения счета (ты ее устанавливаешь из ScoreLabel.gd)
var score_label: Label = null

# Функция для добавления очков и обновления текста
func add_score(amount: int):
	score += amount
	print("Score increased to: ", score) # Для отладки
	update_score_label()

# Функция для обновления текста Label
func update_score_label():
	if score_label != null:
		score_label.text = "Score: " + str(score)
		print("Score label updated to: ", score_label.text) # Для отладки
	else:
		# Это предупреждение сработает, если монета соберется ДО того,
		# как сцена с Label загрузится и выполнит _ready()
		push_warning("Score label reference not set in Global script!")
