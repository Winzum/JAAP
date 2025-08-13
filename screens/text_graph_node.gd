extends GraphNode
@onready var graph_edit = get_parent()

func initialize_slot(start_text:String = "") -> void:
	$TextEdit_0.text = start_text
	set_slot(1, true, 1, Color.RED, true, 1, Color.BLUE)

#TODO merge with the method?
func add_known_field(field_port: int, field_name: String, field_text: String) -> void:
	var text_edit_new = TextEdit.new()
	text_edit_new.custom_minimum_size = Vector2(0,40)
	text_edit_new.name = field_name
	text_edit_new.text = field_text
	set_slot(field_port+1, false, 1, Color.RED, true, 1, Color.BLUE)
	add_child(text_edit_new)

# adds or removes text slots to the node. Adds if true, removes if false
func _add_node_slots(add: bool) -> void:
	var output_count = get_output_port_count()
	if add:
		var text_edit_new = TextEdit.new()
		text_edit_new.custom_minimum_size = Vector2(0,40)
		text_edit_new.name = "TextEdit_%d" % (output_count)
		set_slot(output_count + 1, false, 1, Color.RED, true, 1, Color.BLUE)
		add_child(text_edit_new)
	elif output_count > 1:
		clear_slot(output_count)
		# for now this is compensated for the popupmenu nodes
		get_child(output_count + 2).queue_free()

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
	$PopupRename.hide()

#returns the text of all textedits of the current node
func get_textedit_text() -> Dictionary:
	var texts = {}
	var text_edits = find_children("TextEdit_*", "", false, false)
	for i in text_edits.size():
		texts[i] = text_edits[i].text
	return texts
