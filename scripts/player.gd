extends CharacterBody3D

var ORIGINAL_SPEED
var SPEED = 3.0
var SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	ORIGINAL_SPEED = SPEED
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if Input.is_action_just_pressed("sprint"):
			SPEED = SPRINT_SPEED
		if Input.is_action_just_released("sprint"):
			SPEED = ORIGINAL_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_attract_collectables_area_area_entered(area: Area3D) -> void:
	if area is Collectable:
		if not area.isCollected:
			print("Coin detected! Adding score.") # Для отладки
			Global.add_score(1) # Добавляем 1 очко (или другое значение, если нужно)
			area.isCollected = true
