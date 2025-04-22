extends StaticBody3D

# --- Настраиваемые переменные ---
# Сколько монет нужно для открытия
@export var required_score := 13
# Угол, на который откроется дверь (в градусах по оси Y)
@export var open_rotation_degrees := 90.0
# Скорость открытия двери (в секундах)
@export var open_duration := 1.0

# --- Внутренние переменные ---
# Ссылка на узел пивота (если используешь)
@onready var pivot: Node3D = $Pivot
# Ссылка на форму коллизии, которую будем отключать
@onready var collision_shape: CollisionShape3D = $Pivot/CollisionShape3D
# Ссылка на зону взаимодействия
@onready var interaction_area: Area3D = $InteractionArea
# (Опционально) Ссылка на звук
# @onready var open_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Флаги состояния
var is_open := false
var is_opening := false # Чтобы не запускать анимацию повторно

func _ready():
	# Подключаем сигнал от зоны взаимодействия к нашей функции
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)

# Эта функция вызывается, когда тело (например, игрок) входит в InteractionArea
func _on_interaction_area_body_entered(body):
	# Проверяем, открыта ли дверь или уже открывается
	if is_open or is_opening:
		return

	# Проверяем, является ли вошедшее тело игроком (по группе "player")
	# Убедись, что у твоего игрока добавлена эта группа в его _ready()
	if body.is_in_group("player"):
		print("Player entered door area. Current score:", Global.score) # Отладка
		# Проверяем, достаточно ли очков
		if Global.score >= required_score:
			print("Enough score! Opening door.") # Отладка
			open_door()
		else:
			print("Not enough score. Need", required_score) # Отладка
			# Тут можно добавить звук "заперто" или сообщение игроку

# Функция для открытия двери
func open_door():
	# Ставим флаг, что дверь открывается (предотвращает повторный вызов)
	is_opening = true

	# (Опционально) Воспроизводим звук
	# if open_sound:
	#    open_sound.play()

	# Создаем анимацию Tween для плавного открытия
	var tween = create_tween()
	tween.set_parallel(false) # Анимации будут выполняться последовательно (если их несколько)
	tween.set_trans(Tween.TRANS_SINE) # Тип перехода (смягчение)

	# Анимируем поворот узла Pivot
	tween.tween_property(pivot, "rotation_degrees:y", open_rotation_degrees, open_duration)
	#                      ^ Объект     ^ Свойство        ^ Конечное знач. ^ Длительность

	# Ждем завершения анимации поворота
	await tween.finished

	# Дверь полностью открыта
	is_open = true
	is_opening = false

	# --- ОЧЕНЬ ВАЖНО: Отключаем коллизию двери, чтобы игрок мог пройти ---
	collision_shape.disabled = true

	# Опционально: можно отключить и зону взаимодействия, чтобы сигнал больше не срабатывал
	interaction_area.monitoring = false

	print("Door is now open and collision disabled.") # Отладка
