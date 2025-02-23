extends CanvasLayer

signal show_main_menu


func _on_quit_button_pressed():
	show_main_menu.emit()
