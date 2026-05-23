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
	
func _on_inicio_button_pressed() -> void:
	$InicioButton.hide()
	start_game.emit()

func _on_mensagem_timer_timeout() -> void:
	$MensagemLabel.hide()
