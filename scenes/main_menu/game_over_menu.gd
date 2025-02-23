extends CanvasLayer

signal start_game(starting_player: int)


func _on_start_game_button_pressed():
	start_game.emit(1)



func _on_quit_button_pressed():
	get_tree().quit()
