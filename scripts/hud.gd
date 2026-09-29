extends CanvasLayer

signal start_game

func update_score(value):
	$MarginContainer/ScoreLabel.text = str(value)

func update_timer(value):
	$MarginContainer/TimerLabel.text = str(value)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$StartButton.show()
	$MessageLabel.text = "Coin Dash!"
	$MessageLabel.show()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$MessageLabel.hide()
	emit_signal("start_game")

func _on_message_timer_timeout() -> void:
	$MessageLabel.hide()
