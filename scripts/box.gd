# Box.gd
extends CharacterBody2D

@export var kick_speed: float = 250.0
var move_direction: Vector2 = Vector2.ZERO
var is_moving: bool = false

func _ready() -> void:
	add_to_group("boxes")

# chamado pelo player quando ataca
func kick(direction: Vector2) -> void:
	move_direction = direction.normalized()
	velocity = move_direction * kick_speed
	print_debug("entrou aqui")
	is_moving = true

func _physics_process(delta: float) -> void:
	if is_moving:
		print_debug("esta movendo", velocity)
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = Vector2.ZERO
			is_moving = false
