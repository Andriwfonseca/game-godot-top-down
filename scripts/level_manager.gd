extends Node2D

@export var target_quantity: int = 4

# Controle de targets
var occupied_targets: int = 0
var targets: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Adiciona ao grupo level_manager para comunicação
	add_to_group("level_manager")

	# Encontra todos os targets na cena
	await get_tree().process_frame
	find_targets()

	print("Level Manager inicializado. Targets encontrados: ", targets.size())
	print("Targets necessários para completar: ", target_quantity)

# Encontra todos os targets na cena
func find_targets() -> void:
	targets.clear()

	# Procura por todos os nós que pertencem ao grupo "targets"
	var target_nodes = get_tree().get_nodes_in_group("targets")

	for target in target_nodes:
		targets.append(target)
		print("Target encontrado: ", target.name)

# Chamado quando um target é ocupado
func on_target_occupied(target: Node) -> void:
	occupied_targets += 1
	print("Target ocupado! Progresso: ", occupied_targets, "/", target_quantity)

	# Verifica se todos os targets foram ocupados
	if occupied_targets >= target_quantity:
		level_completed()

# Chamado quando um target é desocupado
func on_target_unoccupied(target: Node) -> void:
	occupied_targets -= 1
	print("Target desocupado! Progresso: ", occupied_targets, "/", target_quantity)

# Finaliza o level quando todos os targets estão ocupados
func level_completed() -> void:
	print("🎉 LEVEL COMPLETADO! 🎉")

	# Aqui você pode adicionar:
	# - Som de vitória
	# - Animação de transição
	# - Carregar próximo level
	# - Mostrar tela de vitória

	# Por enquanto, apenas recarrega a cena após 2 segundos
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

# Função para verificar o progresso atual
func get_progress() -> float:
	if target_quantity == 0:
		return 0.0
	return float(occupied_targets) / float(target_quantity)

# Função para obter texto de progresso
func get_progress_text() -> String:
	return str(occupied_targets) + "/" + str(target_quantity)
