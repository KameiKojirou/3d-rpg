extends TextureButton
class_name ItemIcon

signal interact(item)

@onready var stat_label = $MarginContainer/StatLabel
@onready var item_label = $MarginContainer/ItemLabel


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("click"):
		interact.emit(self)
