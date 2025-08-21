extends CharacterBody2D

@export var speed: float = 120.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: String = "down" # guarda a última direção para idle

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	# Captura movimento (setas ou WASD)
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Normaliza para não ficar mais rápido na diagonal
	input_vector = input_vector.normalized()

	# Define a velocidade
	velocity = input_vector * speed

	# Move e desliza automaticamente nas colisões
	move_and_slide()

	# ---- Animação ----
	if input_vector == Vector2.ZERO:
		# Idle (parado, usa última direção)
		anim.play("idle_" + last_direction)
	else:
		# Run (movendo)
		if abs(input_vector.x) > abs(input_vector.y):
			# Horizontal
			if input_vector.x > 0:
				anim.play("run_right")
				last_direction = "right"
			else:
				anim.play("run_left")
				last_direction = "left"
		else:
			# Vertical
			if input_vector.y > 0:
				anim.play("run_down")
				last_direction = "down"
			else:
				anim.play("run_up")
				last_direction = "up"
