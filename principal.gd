extends Node2D
var mob_scene = preload("res://inimigo.tscn")
var score

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$PontuacaoTimer.stop()
	$InimigoTimer.stop()

func new_game() -> void:
	score = 0
	$Jogador.start($InicioPosicao.position)
	$InicioTimer.start()
	
func _on_inimigo_timer_timeout() -> void:
	# criar a instancia de um inimigo
	var inimigo = mob_scene.instantiate()
	
	var inimigo_spawn_localizacao = $InimigoPath/InimigoSpawnLocalizacao
	inimigo_spawn_localizacao.progress_ratio = randf()
	
	inimigo.position = inimigo_spawn_localizacao.position
	
	var direction = inimigo_spawn_localizacao.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	inimigo.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.00)
	inimigo.linear_velocity = velocity.rotated(direction)
	
	add_child(inimigo)

func _on_pontuacao_timer_timeout() -> void:
	score += 1

func _on_inicio_timer_timeout() -> void:
	$InimigoTimer.start()
	$PontuacaoTimer.start()
