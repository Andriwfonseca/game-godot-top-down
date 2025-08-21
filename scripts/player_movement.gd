extends CharacterBody2D

@export var speed: float = 120.0
@export var attack_offset: float = 16.0   # distância da hitbox em relação ao centro

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_shape: CollisionShape2D = $AttackArea/CollisionShape2D

var last_direction: String = "down" # guarda última direção
var attacking: bool = false         # trava o movimento enquanto ataca

# ----------------- Ataque -----------------
func update_attack_area_position() -> void:
	match last_direction:
		"up":
			attack_area.position = Vector2(0, -attack_offset)
		"down":
			attack_area.position = Vector2(0, attack_offset)
		"left":
			attack_area.position = Vector2(-attack_offset, 0)
		"right":
			attack_area.position = Vector2(attack_offset, 0)

func start_attack(base_anim: String) -> void:
	attacking = true
	velocity = Vector2.ZERO
	anim.play(base_anim + last_direction)

	# Ativa a hitbox do ataque
	attack_area.monitoring = true

	anim.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)

func _on_attack_finished() -> void:
	attacking = false
	attack_area.monitoring = false

func _on_attack_area_body_entered(body: Node) -> void:
	# LOG para depuração
	print_debug("Hit detectado! Colidiu com: ", body.name)

	if body.is_in_group("boxes"): # adicione sua Box no grupo "boxes"
		var dir := Vector2.ZERO
		match last_direction:
			"up": dir = Vector2.UP
			"down": dir = Vector2.DOWN
			"left": dir = Vector2.LEFT
			"right": dir = Vector2.RIGHT
		body.kick(dir)

# ----------------- Ciclo de Vida -----------------
func _ready() -> void:
	attack_area.monitoring = false
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))

# ----------------- Movimento -----------------
func _physics_process(delta: float) -> void:
	# Se estiver atacando, não deixa mover
	if attacking:
		return

	var input_vector := Vector2.ZERO

	# Captura movimento (setas ou WASD)
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = input_vector * speed
	move_and_slide()

	# ---- Animação de movimento/idle ----
	if input_vector == Vector2.ZERO:
		anim.play("idle_" + last_direction)
	else:
		if abs(input_vector.x) > abs(input_vector.y):
			last_direction = "right" if input_vector.x > 0 else "left"
			anim.play("run_" + last_direction)
		else:
			last_direction = "down" if input_vector.y > 0 else "up"
			anim.play("run_" + last_direction)

	# ---- Ataque ----
	if Input.is_action_just_pressed("attack1"):
		start_attack("attack1_")
	elif Input.is_action_just_pressed("attack2"):
		start_attack("attack2_")

	update_attack_area_position()
