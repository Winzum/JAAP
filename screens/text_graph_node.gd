extends GraphNode

@onready var graph_edit = get_parent()

func _ready() -> void:
	set_slot(1, true, 1, Color.RED, true, 1, Color.BLUE)

# adds or removes the amount of node output slots to the node
func _add_node_slots(n: int) -> void:
	var output_count = get_output_port_count()
	if n < 0:
		# ensure 1 output always remains
		var remove_count = min(-n, output_count -1)
		for i in range(remove_count):
			clear_slot(output_count)
			# for now this is compensated for the popupmenu nodes
			get_child(output_count+2).queue_free()
			output_count = get_output_port_count()
	elif n > 0:
		for i in range(n):
			var text_edit_new = TextEdit.new()
			text_edit_new.custom_minimum_size = Vector2(0,40)
			print("TextEdit_%d" % (output_count + i))
			text_edit_new.name = "TextEdit_%d" % (output_count  + i)
			set_slot(output_count + 1 + i, false, 1, Color.RED, true, 1, Color.BLUE)
			add_child(text_edit_new)		

func _on_close_button_pressed() -> void:
	queue_free()

func _on_gui_input(event: InputEvent) -> void:
	#on right click
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		var popup_location = get_global_transform().origin + (event.position * graph_edit.zoom)
		$PopupMenu.position = popup_location
		$PopupRename.position = popup_location
		$PopupMenu.show()

func _on_popup_menu_index_pressed(index: int) -> void:
	match index:
		0:
			$PopupRename.show()
			$PopupRename/LineEdit.grab_focus()

func _on_rename_text_submitted(new_text: String) -> void:
	title = new_text
	name = new_text
	$PopupRename.hide()
