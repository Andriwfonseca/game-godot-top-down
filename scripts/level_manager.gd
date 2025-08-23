extends Node2D

@export var target_quantity: int = 4
@export var current_level: int = 1

# Controle de targets
var occupied_targets: int = 0
var targets: Array[Node] = []
var door: Node = null # Referência para a door

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Adiciona ao grupo level_manager para comunicação
	add_to_group("level_manager")

	# Encontra todos os targets na cena
	await get_tree().process_frame
	find_targets()
	find_door()

	print("Level Manager inicializado. Targets encontrados: ", targets.size())
	print("Targets necessários para completar: ", target_quantity)

	# Instancia o virtual joystick
	var touch_controls_scene = preload("res://scenes/Game/touch_controls.tscn")
	var touch_controls = touch_controls_scene.instantiate()
	add_child(touch_controls)


# Encontra todos os targets na cena
func find_targets() -> void:
	targets.clear()

	# Procura por todos os nós que pertencem ao grupo "targets"
	var target_nodes = get_tree().get_nodes_in_group("targets")

	for target in target_nodes:
		targets.append(target)
		print("Target encontrado: ", target.name)

# Encontra a door na cena
func find_door() -> void:
	# Procura por um nó chamado "Door" ou que pertença ao grupo "doors"
	door = get_tree().get_first_node_in_group("doors")

	if not door:
		# Tenta encontrar por nome
		door = get_node_or_null("../Door")

	if door:
		print("Door encontrada: ", door.name)
	else:
		print("⚠️ Door não encontrada!")

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
	destroy_door()

	# Aqui você pode adicionar:
	# - Som de vitória
	# - Animação de transição
	# - Carregar próximo level
	# - Mostrar tela de vitória

	# Por enquanto, apenas recarrega a cena após 2 segundos
	await get_tree().create_timer(1.0).timeout

	print("current_level: ", current_level)

	match current_level:
		1:
			print("level 1")
			get_tree().change_scene_to_file("res://scenes/Levels/level-2.tscn")
		2:
			print("level 2")
			get_tree().change_scene_to_file("res://scenes/Levels/level-3.tscn")
		3:
			print("level 3")
			get_tree().change_scene_to_file("res://scenes/Levels/level-4.tscn")
		4:
			print("level 4")
			get_tree().change_scene_to_file("res://scenes/Levels/level-5.tscn")
		5:
			print("level 5")
			get_tree().change_scene_to_file("res://scenes/Levels/level.tscn")

# Função para verificar o progresso atual
func get_progress() -> float:
	if target_quantity == 0:
		return 0.0
	return float(occupied_targets) / float(target_quantity)

# Função para obter texto de progresso
func get_progress_text() -> String:
	return str(occupied_targets) + "/" + str(target_quantity)

	# Destrói a door
func destroy_door() -> void:
	if door:
		print("🚪 Destruindo door: ", door.name)
		door.queue_free() # Remove a door da cena
	else:
		print("⚠️ Door não encontrada para destruir!")
