extends Sprite2D

# Script para o Box Target - Detecta quando uma box está em cima

@onready var area: Area2D = $Area2D

var is_occupied: bool = false
var occupied_by: CharacterBody2D = null

func _ready() -> void:
	# Conecta o sinal de body_entered
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

	# Adiciona ao grupo de targets
	add_to_group("targets")

func _on_body_entered(body: Node) -> void:
	# Verifica se é uma box
	if body.is_in_group("boxes"):
		is_occupied = true
		occupied_by = body
		print("Target ocupado por box: ", body.name)

		# Notifica o level manager
		get_tree().call_group("level_manager", "on_target_occupied", self)

func _on_body_exited(body: Node) -> void:
	# Verifica se é a mesma box que entrou
	if body == occupied_by:
		is_occupied = false
		occupied_by = null
		print("Target desocupado: ", body.name)

		# Notifica o level manager
		get_tree().call_group("level_manager", "on_target_unoccupied", self)

# Função para verificar se está ocupado
func is_target_occupied() -> bool:
	return is_occupied

# Função para obter a box que está ocupando
func get_occupying_box() -> CharacterBody2D:
	return occupied_by
