extends CanvasLayer

signal show_in_game_menu


func _on_menu_button_pressed():
	show_in_game_menu.emit()
