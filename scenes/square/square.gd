extends Area2D
class_name Square

signal square_pressed(square: Square)

@export var grid_position: Vector2i = Vector2i(0,0)


func reset():
	$Face.texture = null
	set_button_visability(true)


func get_grid_position() -> Vector2i:
	return grid_position


func set_button_visability(visable : bool):
	$Button.visible = visable


func set_face_texture(player_symbol : CompressedTexture2D):
	$Face.texture = player_symbol


func _on_button_pressed():
	square_pressed.emit()
