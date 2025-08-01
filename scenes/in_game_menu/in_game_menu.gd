extends Control

signal continue_game
signal quit_game

@onready var label = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var continue_button = $PanelContainer/MarginContainer/VBoxContainer/ContinueButton
@onready var quit_button = $PanelContainer/MarginContainer/VBoxContainer/QuitButton


func update_label(text: String) -> void:
	label.text = text
	
	
func show_continue_button(show_button: bool) -> void:
	if show_button:
		continue_button.show()
	else:
		continue_button.hide()
	

func show_quit_button(show_button: bool) -> void:
	if show_button:
		quit_button.show()
	else:
		quit_button.hide()


func _on_continue_button_pressed():
	continue_game.emit()


func _on_quit_button_pressed():
	quit_game.emit()
