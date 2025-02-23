extends CanvasLayer

signal continue_game
signal quit_game


func _on_continue_button_pressed():
	continue_game.emit()


func _on_quit_button_pressed():
	quit_game.emit()
