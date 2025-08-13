extends PopupMenu
@onready var graph_edit = $"../VBoxContainer/GraphEdit"

var last_global_position: Vector2

func _on_graph_edit_gui_input(event: InputEvent) -> void:
	#on right click
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		last_global_position = event.global_position
		position = event.position + Vector2(0, size.y/2)
		show()

func _on_index_pressed(index: int) -> void:
	match index:
		# add text
		0: 
			print(last_global_position)
			var pos = (graph_edit.scroll_offset / graph_edit.zoom) + (last_global_position / graph_edit.zoom)
			graph_edit.add_graph_node({"position": pos})
