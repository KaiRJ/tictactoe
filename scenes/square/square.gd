extends Button
class_name Square

signal square_pressed(square: Square)

@export var grid_position: Vector2i = Vector2i(0,0)


func reset():
	set_icon(null)
	disable(false)
	self.add_to_group("free_squares")


func set_icon(player: CompressedTexture2D):
	self.icon = player


func disable(dis: bool):
	self.disabled = dis


func _on_pressed() -> void:
	disable(true)
	self.remove_from_group("free_squares")
	square_pressed.emit()
