extends CanvasLayer
signal start_game

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func show_message(text) -> void:
	$MensagemLabel.text = text
	$MensagemLabel.show()
	$MensagemTimer.start()

func show_game_over():
	show_message("Game Over")
	
	await $MensagemTimer.timeout
	
	$MensagemLabel.text = "Dodge the Creeps!"
	$MensagemLabel.show()
	
	await get_tree().create_timer(1.0).timeout
	$InicioButton.show()

func update_score(score):
	$PontuacaoLabel.text = str(score)

func atualizar_vida(vidas: int):
	var coracoes = $VidaContainer/VidaAlinhamentoH.get_children()
	for i in range(coracoes.size()):
		var coracao = coracoes[i]
		if(i >= vidas):
			coracao.modulate = Color(0.5, 0.5, 0.5)

func voltar_vidas_jogador():
	var coracoes = $VidaContainer/VidaAlinhamentoH.get_children()
	for coracao in coracoes:
		coracao.modulate = Color(1, 1, 1, 1) 
	
func _on_inicio_button_pressed() -> void:
	$InicioButton.hide()
	voltar_vidas_jogador()
	start_game.emit()

func _on_mensagem_timer_timeout() -> void:
	$MensagemLabel.hide()
