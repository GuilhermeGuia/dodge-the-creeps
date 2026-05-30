extends Area2D
signal hit
signal dano

@export var life = 3
@export var speed = 200
var screen_size
var invencibilidade = false

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Chamado na primeira vez que a cena é rodada -> como um metodo construtor
func _ready() -> void:
	# pegar o tamanho da tela do jogador
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	# logica para identificar qual teclado o jogador apertou e mudar a velocidade
	# estava usando is_action_just_pressed -> se jogador segurar a tecla retorna TRUE
	# uma unica vez -> bom para abrir menu, pulo, teclas especificar
	# nesse caso -> recomendada usar em movimentos do jogador
	if Input.is_action_pressed("mover_direita"):
		velocity.x += 1
	if Input.is_action_pressed("mover_esquerda"):
		velocity.x -= 1
	if Input.is_action_pressed("mover_cima"):
		velocity.y -= 1
	if Input.is_action_pressed("mover_baixo"):
		velocity.y += 1
	
	velocity = normalizar_velocidade_jogador(velocity)
	atualizar_animacao_jogador(velocity)
		
	mover_jogador(velocity, delta)
	
	# alterando as sprites de animação -> SE o X for diferente de 0
	# significa -> que o player esta andando pra pra esquerda ou direta
	# SE o Y for diferente de 0 então o player esta andando pra cima ou para baixo
	ajustar_sprit_movimento(velocity)

func _on_body_entered(body: Node2D) -> void:
	levar_dano()
	
func ajustar_sprit_movimento(velocity: Vector2):
	var movimentoEsquerdaOuDireta = velocity.x != 0
	var movimentoCimaOuBaixo = velocity.y != 0
	if movimentoEsquerdaOuDireta:
		ajustar_sprite_movimento_direita_esquerda(velocity)
	elif movimentoCimaOuBaixo:
		ajustar_sprite_movimento_cima_baixo(velocity)

func levar_dano():
	if invencibilidade: return
	# nao pode tomar dano seguido
	life -= 1
	dano.emit(life)
	if(life < 1): game_over()
	else: iniciar_invencibilidade()

func iniciar_invencibilidade():
	invencibilidade = true
	ajustar_sprit_invencibilidade()
	$InvencibilidadeTimer.start()

func game_over():
	hide()
	hit.emit()
	# desativa o estado de colisão do jogador de forma segura
	life = 3
	$CollisionShape2D.set_deferred("disabled", true)

func mover_jogador(velocity: Vector2, delta: float):
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func ajustar_sprite_movimento_direita_esquerda(velocity: Vector2):
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0

func ajustar_sprite_movimento_cima_baixo(velocity: Vector2):
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func atualizar_animacao_jogador(velocity: Vector2):
	var jogadorEstaSeMovendo = velocity.length() > 0
	if jogadorEstaSeMovendo:
		$AnimatedSprite2D.play()
	else: 
		$AnimatedSprite2D.stop()

func normalizar_velocidade_jogador(velocity: Vector2) -> Vector2:
	return velocity.normalized() * speed if velocity.length() > 0 else velocity

func _on_invencibilidade_timer_timeout() -> void:
	invencibilidade = false
	ajustar_sprit_invencibilidade()
	$InvencibilidadeTimer.stop()

func ajustar_sprit_invencibilidade():
	var sprite = $AnimatedSprite2D
	if invencibilidade: sprite.modulate = Color(1,1, 1, 0.5)
	else: sprite.modulate = Color(1, 1, 1, 1) 
