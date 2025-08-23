extends CharacterBody2D

@export var grid_size: float = 16.0
@export var kick_speed: float = 250.0

var move_direction: Vector2 = Vector2.ZERO
var is_moving: bool = false

func _ready() -> void:
	add_to_group("boxes")

# Função para alinhar posição na grid
func align_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		round(pos.x / grid_size) * grid_size,
		round(pos.y / grid_size) * grid_size
	)

# chamado pelo player quando ataca
func kick(direction: Vector2) -> void:
	move_direction = direction.normalized()
	velocity = move_direction * kick_speed
	print_debug("entrou aqui")
	is_moving = true

func _physics_process(delta: float) -> void:
	if is_moving:
		var collision = move_and_collide(velocity * delta)
		if collision:
			# Verifica se colidiu com um target
			var collider = collision.get_collider()
			if collider and collider.is_in_group("targets"):
				# Atravessa o target (não para)
				print("Atravessando target: ", collider.name)
				# Continua o movimento
			else:
				# Para apenas se não for um target
				velocity = Vector2.ZERO
				is_moving = false

				# Alinha a posição na grid
				position = align_to_grid(position)
